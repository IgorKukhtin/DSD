-- Function: gpInsertUpdate_Object_GoodsBarCode_Load_Price_Test

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsBarCode_Load_Price_Test (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsBarCode_Load_Price_Test (
    IN inJuridicalId      Integer,   -- Поставщик
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);
      
      
      IF COALESCE (inJuridicalId, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка. Не выбрано юр.лицо';
      END IF;
            
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 11.07.17         *
*/
