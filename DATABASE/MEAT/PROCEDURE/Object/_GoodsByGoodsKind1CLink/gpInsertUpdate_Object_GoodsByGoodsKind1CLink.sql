-- Function: gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind1CLink(
    IN inId                     Integer,    -- ключ объекта <Счет>
    IN inCode                   Integer,    -- Код объекта <Счет>
    IN inName                   TVarChar,   -- Название объекта <Счет>
    IN inGoodsByGoodsKindId     Integer,    -- 
    IN inBranchId               Integer,    -- 
    IN inBranchTopId            Integer,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS TABLE (Id Integer, BranchId Integer, BranchName TVarChar)
AS
$BODY$
  DECLARE vbBranchId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind1CLink());

   -- сохранили <Объект>
   inId := lpInsertUpdate_Object (inId, zc_Object_GoodsByGoodsKind1CLink(), inCode, inName);

   IF COALESCE(inBranchId, 0) = 0 THEN
      vbBranchId := inBranchTopId;
   ELSE
      vbBranchId := inBranchId;
   END IF;

   IF COALESCE(vbBranchId, 0) = 0 THEN
       RAISE EXCEPTION 'Не установлен филиал';
   END IF;


   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind(), inId, inGoodsByGoodsKindId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind1CLink_Branch(), inId, vbBranchId);

   RETURN 
     QUERY SELECT inId, Object.Id, Object.ValueData
           FROM Object WHERE Object.Id = vbBranchId;
   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.08.13                        *
*/
