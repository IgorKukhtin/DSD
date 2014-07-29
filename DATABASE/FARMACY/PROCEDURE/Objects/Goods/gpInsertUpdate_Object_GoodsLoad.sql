-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLoad(Integer, Integer, TVarChar, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsLoad(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                Integer   ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDS                 TFloat     ,    -- НДС

    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS integer AS
$BODY$
DECLARE vbNDSKindId Integer;
BEGIN

    IF inNDS = 20 THEN 
       vbNDSKindId  := zc_Enum_NDSKind_Common();
    ELSE
       vbNDSKindId  := zc_Enum_NDSKind_Medical();
    END IF; 

    ioId := lpInsertUpdate_Object_Goods(ioId, inCode, inName, inMeasureId, vbNDSKindId, 0, 0, inSession);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLoad(Integer, Integer, TVarChar, Integer, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.14         *
 19.06.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
