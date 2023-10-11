-- Function: gpInsertUpdate_RewiringHistoryCost (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpInsertUpdate_RewiringHistoryCost (TDateTime, TDateTime, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpInsertUpdate_RewiringHistoryCost(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inBranchId        Integer , --
    IN inItearationCount Integer , --
    IN inInsert          Integer , --
    IN inDiffSumm        TFloat , --
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (Transaction_Id        BIGINT
             , CountRecord           INTEGER 
               ) 
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbCountRecord    Integer;
   DECLARE vbTransaction_Id BIGINT;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   vbTransaction_Id := txid_current();

   SELECT count(*) 
   INTO vbCountRecord
   FROM gpInsertUpdate_HistoryCost (inStartDate:= inStartDate
                                  , inEndDate:= inEndDate
                                  , inBranchId:= inBranchId
                                  , inItearationCount:= inItearationCount
                                  , inInsert:= inInsert
                                  , inDiffSumm:= inDiffSumm
                                  , inSession:= inSession);

      -- Результат
   RETURN QUERY
   SELECT vbTransaction_Id, vbCountRecord;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.23                                                       * 
*/

-- Тест

-- 

select * from _replica.gpInsertUpdate_RewiringHistoryCost(inStartDate:= '01.10.2023', inEndDate:= '31.10.2023', inBranchId:= 8379, inItearationCount := 50, inInsert := -1, inDiffSumm := 1, inSession:= zfCalc_UserAdmin());