-- Function: gpDelete_ObjectBoolean_Goods_IsSpecCondition()

DROP FUNCTION IF EXISTS gpDelete_ObjectBoolean_Goods_IsSpecCondition(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_ObjectBoolean_Goods_IsSpecCondition(
    IN inObjectId            Integer   ,    -- код поставщика
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN
    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите поставщика';
    END IF;
    DELETE FROM ObjectBoolean
    WHERE
        DescId = zc_ObjectBoolean_Goods_SpecCondition()
        AND
        ObjectId IN (
            Select DISTINCT 
                ObjectLink_Goods_Object.ObjectId
            FROM
                ObjectLink AS ObjectLink_Goods_Object
            WHERE
                ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                AND
                ObjectLink_Goods_Object.ChildObjectId = inObjectId);
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_ObjectBoolean_Goods_IsSpecCondition(Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 18.02.16         *
*/