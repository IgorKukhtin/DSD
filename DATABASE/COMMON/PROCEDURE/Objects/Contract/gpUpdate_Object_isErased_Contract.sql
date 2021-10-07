-- Function: gpUpdate_Object_isErased_Contract (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Contract (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Contract(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDebts TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_Contract());

   --когда удаляют договор или ставят статус - закрыт, не должно быть  долгов (погрешнось в 1 грн, т.е. когда долг >1 или <-1)
   vbDebts := (SELECT tmp.Amount FROM gpGet_Object_Contract_debts (inObjectId, inSession) AS tmp);
   IF COALESCE (vbDebts, 0) <> 0 
   THEN
       RAISE EXCEPTION 'Ошибка.По договору <%> есть долг в сумме <%>.', lfGet_Object_ValueData (inObjectId), vbDebts;
   END IF;


   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_Contract (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.05.14                                        *
*/
