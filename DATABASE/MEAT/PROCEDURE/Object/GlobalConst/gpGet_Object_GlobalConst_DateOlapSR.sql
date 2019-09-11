-- Function: gpGet_Object_GlobalConst_DateOlapSR

DROP FUNCTION IF EXISTS gpGet_Object_GlobalConst_DateOlapSR (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GlobalConst_DateOlapSR (
    IN inSession TVarChar
)
RETURNS TABLE (ProtocolDateOlapSR  TDateTime  --Дата формирования данных Олап Продажа/возврат
             , EndDateOlapSR       TDateTime  --По какую дату включительно сформированы данные Олап Продажа/возврат
              )
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbProtocolDateOlapSR TDateTime;
  DECLARE vbEndDateOlapSR TDateTime;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Дата формирования данных Олап Продажа/возврат
      SELECT ObjectDate_ActualBankStatement.ValueData 
     INTO  vbProtocolDateOlapSR
      FROM  ObjectDate AS ObjectDate_ActualBankStatement
      WHERE ObjectDate_ActualBankStatement.ObjectId = zc_Enum_GlobalConst_ProtocolDateOlapSR()
        AND ObjectDate_ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement();
      
      -- По какую дату включительно сформированы данные Олап Продажа/возврат
      SELECT ObjectDate_ActualBankStatement.ValueData
     INTO vbEndDateOlapSR
      FROM  ObjectDate AS ObjectDate_ActualBankStatement
      WHERE ObjectDate_ActualBankStatement.ObjectId = zc_Enum_GlobalConst_EndDateOlapSR()
        AND ObjectDate_ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement();
      
      -- результат
      RETURN QUERY
        SELECT vbProtocolDateOlapSR ::TDateTime
             , vbEndDateOlapSR
        ;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.09.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_GlobalConst_DateOlapSR (inSession:= zfCalc_UserAdmin());
