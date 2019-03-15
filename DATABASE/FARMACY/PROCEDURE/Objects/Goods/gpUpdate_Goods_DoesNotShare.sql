-- Function: gpUpdate_Goods_isNotUploadSites()

DROP FUNCTION IF EXISTS gpUpdate_Goods_DoesNotShare(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_DoesNotShare(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inDoesNotShare        Boolean   ,    -- Не делить на кассах
   OUT outDoesNotShare       Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN


   IF COALESCE(inId, 0) = 0 THEN
      outDoesNotShare := inDoesNotShare;
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outDoesNotShare := inDoesNotShare;

   IF inDoesNotShare = True or EXISTS(SELECT * FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = inId and ObjectBoolean.DescId = zc_ObjectBoolean_Goods_DoesNotShare())
   THEN
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_DoesNotShare(), inId, inDoesNotShare);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

   END IF;
   

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.03.19        *         

*/

-- тест
-- SELECT * FROM gpUpdate_Goods_DoesNotShare