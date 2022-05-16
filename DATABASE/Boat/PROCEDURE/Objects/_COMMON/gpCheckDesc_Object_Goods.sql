-- Function: gpCheckDesc_Object_Goods()


DROP FUNCTION IF EXISTS gpCheckDesc_Object_Goods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckDesc_Object_Goods(
    IN inId               Integer,
    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS VOID

AS
$BODY$
BEGIN

    
    -- проверка деск документа должен соответствовать кнопке открытия документа 
    IF (select DescId from Object where Id = inId) <> zc_Object_Goods()
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный вид элемента.';
    END IF;   

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.05.22         *
*/

-- SELECT * from gpCheckDesc_Object_Goods (214633,'5')