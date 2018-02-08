-- Function: gpDelete_ObjectFloat_Goods_MinimumLot()

DROP FUNCTION IF EXISTS gpDelete_ObjectFloat_Goods_MinimumLot(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpDelete_ObjectFloat_Goods_MinimumLot(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_ObjectFloat_Goods_MinimumLot(
    IN inObjectId            Integer   ,    -- код поставщика
    IN inAreaId              Integer   ,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN
    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите поставщика';
    END IF;
    
    -- если регион не выбран или в zc_ObjectLink_Goods_Area = NULL, это значит что регион = Днепр = zc_Area_Basis()
    IF COALESCE (inAreaId, 0) = 0 
    THEN
        inAreaId := zc_Area_Basis();      --Днепр
    END IF;
    
    DELETE FROM ObjectFloat
    WHERE DescId = zc_ObjectFloat_Goods_MinimumLot()
      AND ObjectId IN (
                       SELECT DISTINCT ObjectLink_Goods_Object.ObjectId
                       FROM ObjectLink AS ObjectLink_Goods_Object
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area 
                                                 ON ObjectLink_Goods_Area.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
                       WHERE ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                         AND ObjectLink_Goods_Object.ChildObjectId = inObjectId
                         AND COALESCE(ObjectLink_Goods_Area.ChildObjectId, zc_Area_Basis()) = inAreaId
                      );
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 08.02.18         *
 15.08.15                                                         *
 
*/