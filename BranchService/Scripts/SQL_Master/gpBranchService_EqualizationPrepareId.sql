-- Function: _replica.gpBranchService_EqualizationPrepareId (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_EqualizationPrepareId (Integer, TVarChar, TIMESTAMP, BIGINT, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_EqualizationPrepareId( 
    IN inReplServerId           Integer  ,                     -- ID сервера репликации
    IN inUserUpdate             TVarChar,                      -- Кто создавал с филиала  
    IN inDayeStart              TIMESTAMP WITHOUT TIME ZONE,   -- Дата начала
    IN inStartId                BIGINT   ,                     -- Начинать с ID 
    IN inRecordStep             Integer  ,                     -- Количество записей для одного прохода 
    IN inOffsetTime             Integer  ,                     -- Смещение даты
    IN inSession                TVarChar                       -- сессия пользователя
)
RETURNS TABLE (Id Integer, CountRecord Integer, RowCount Integer, LastId BIGINT, DayeEnd TIMESTAMP WITHOUT TIME ZONE) 
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbId             BIGINT;
   DECLARE vbTransactionid  BIGINT;
   DECLARE vbOrd            Integer;
   DECLARE vbDayeEnd        TIMESTAMP WITHOUT TIME ZONE;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
    vbUserId:= inSession::Integer;
    
    DELETE FROM _replica.BranchService_Equalization_Id WHERE ReplServerId = inReplServerId;
          
    -- Когда ID не задано определяем первое ID
    IF COALESCE (inStartId, 0) = 0
    THEN
      INSERT INTO _replica.BranchService_Equalization_Id
      SELECT inReplServerId
           , UD.Id
           , UD.transaction_id
           , UD.Table_Name
           , 0                 AS ValueId
           , 0                 AS DescId
           , UD.Last_Modified
      FROM _replica.table_update_data AS UD 
      WHERE UD.Last_Modified <= inDayeStart
        AND (UD.Operation ILIKE 'INSERT' OR UD.Operation ILIKE 'UPDATE') 
        AND UD.user_name NOT ILIKE COALESCE(inUserUpdate, '')
        AND UD.table_name NOT ILIKE ('MovementItemContainer%')
        AND UD.table_name NOT ILIKE ('%Protocol')
        AND UD.table_name NOT ILIKE ('Container%')
        AND UD.table_name NOT ILIKE ('SoldTable')
        AND UD.table_name NOT ILIKE ('HistoryCost')
      ORDER BY UD.Last_Modified DESC
      LIMIT 1000;

      SELECT Max(UD.ID) 
      INTO vbId
      FROM _replica.BranchService_Equalization_Id AS UD
      WHERE UD.ReplServerId = inReplServerId;

      SELECT UD.Transaction_Id
      INTO vbTransactionid
      FROM _replica.BranchService_Equalization_Id AS UD
      WHERE UD.ReplServerId = inReplServerId
        AND UD.Id = vbId;
        
      SELECT MIN(UD.ID) 
      INTO inStartId
      FROM _replica.BranchService_Equalization_Id AS UD
      WHERE UD.ReplServerId = inReplServerId
        AND UD.Transaction_Id = vbTransactionid;
              
      DELETE FROM _replica.BranchService_Equalization_Id WHERE ReplServerId = inReplServerId;
            
    END IF;

    IF COALESCE (inStartId, 0) = 0
    THEN
      RAISE EXCEPTION 'Невозможно определить первое ID по дате начала обмена...';
    END IF;
    
    INSERT INTO _replica.BranchService_Equalization_Id
    SELECT inReplServerId
         , UD.Id
         , UD.transaction_id
         , UD.Table_Name
         , CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[2] 
                ELSE UD.pk_values END::Integer   AS ValueId
         , CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[1] 
                ELSE '0' END::Integer              AS DescId
         , UD.Last_Modified
         , UD.Operation ILIKE 'INSERT'  AS isInsert
    FROM _replica.table_update_data AS UD 

         LEFT JOIN MovementItem ON MovementItem.ID = CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                                                   THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[2] 
                                                   ELSE UD.pk_values END::Integer
                               AND UD.table_name ILIKE ('MovementItem%') 

         LEFT JOIN Movement ON Movement.ID = CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                                                   THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[2] 
                                                   ELSE UD.pk_values END::Integer
                           AND Movement.DescID IN (SELECT DFM.DescId FROM _replica.BranchService_DescId_ForMovement AS DFM)
                           AND UD.table_name ILIKE ('Movement%') 
                           AND UD.table_name NOT ILIKE ('MovementItem%') 
                            OR Movement.ID = MovementItem.MovementId
                           AND UD.table_name ILIKE ('MovementItem%')

    WHERE UD.ID >= inStartId
      AND (UD.Operation ILIKE 'INSERT' OR UD.Operation ILIKE 'UPDATE') 
      AND UD.user_name NOT ILIKE COALESCE(inUserUpdate, '')
      AND UD.table_name NOT ILIKE ('MovementItemContainer%')
      AND UD.table_name NOT ILIKE ('%Protocol')
      AND UD.table_name NOT ILIKE ('Container%')
      AND UD.table_name NOT ILIKE ('SoldTable')
      AND UD.table_name NOT ILIKE ('HistoryCost')
      AND (UD.table_name NOT ILIKE ('Movement%') OR COALESCE(Movement.ID, 0) <> 0)
    ORDER BY UD.ID
    LIMIT inRecordStep;
    
    -- Ограничим по Смещение даты
    DELETE FROM _replica.BranchService_Equalization_Id 
    WHERE _replica.BranchService_Equalization_Id.ReplServerId = inReplServerId
      AND _replica.BranchService_Equalization_Id.Last_Modified > timezone('utc'::text, CLOCK_TIMESTAMP()) - (inOffsetTime::TEXT||' MIN')::INTERVAL;
    
    IF EXISTS(SELECT 1 FROM _replica.BranchService_Equalization_Id LIMIT 1)
    THEN
      -- Убераем последнюю целую транзакцию на дату конца выборки

      SELECT MAX(UD.ID) 
      INTO vbId
      FROM _replica.BranchService_Equalization_Id AS UD
      WHERE UD.ReplServerId = inReplServerId;
      
      SELECT UD.Transaction_Id
      INTO vbTransactionid
      FROM _replica.BranchService_Equalization_Id AS UD
      WHERE UD.ReplServerId = inReplServerId
        AND UD.Id = vbId;
        
      SELECT MIN(UD.ID) 
      INTO vbId
      FROM _replica.BranchService_Equalization_Id AS UD
      WHERE UD.ReplServerId = inReplServerId
        AND UD.Transaction_Id = vbTransactionid;

      DELETE FROM _replica.BranchService_Equalization_Id 
      WHERE _replica.BranchService_Equalization_Id.ReplServerId = inReplServerId
        AND _replica.BranchService_Equalization_Id.Id >= vbId
        AND _replica.BranchService_Equalization_Id.Transaction_Id = vbTransactionid;

      IF NOT EXISTS(select UD.Id from _replica.BranchService_Equalization_Id AS UD WHERE UD.ReplServerId = inReplServerId) AND
         COALESCE (vbTransactionid, 0) <> 0
      THEN
        INSERT INTO _replica.BranchService_Equalization_Id
        SELECT inReplServerId
             , UD.Id
             , UD.transaction_id
             , UD.Table_Name
             , CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                    THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[2] 
                    ELSE UD.pk_values END::Integer   AS ValueId
             , CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                    THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[1] 
                    ELSE '0' END::Integer              AS DescId
             , UD.Last_Modified
             , UD.Operation ILIKE 'INSERT'  AS isInsert
        FROM _replica.table_update_data AS UD 
        
             LEFT JOIN MovementItem ON MovementItem.ID = CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                                                       THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[2] 
                                                       ELSE UD.pk_values END::Integer
                                   AND UD.table_name ILIKE ('MovementItem%') 

             LEFT JOIN Movement ON Movement.ID = CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                                                       THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[2] 
                                                       ELSE UD.pk_values END::Integer
                               AND Movement.DescID IN (SELECT DFM.DescId FROM _replica.BranchService_DescId_ForMovement AS DFM)
                               AND UD.table_name ILIKE ('Movement%') 
                               AND UD.table_name NOT ILIKE ('MovementItem%') 
                                OR Movement.ID = MovementItem.MovementId
                               AND UD.table_name ILIKE ('MovementItem%')
                               
        WHERE UD.ID >= inStartId
          AND UD.transaction_id = vbTransactionid
          AND (UD.Operation ILIKE 'INSERT' OR UD.Operation ILIKE 'UPDATE') 
          AND UD.user_name NOT ILIKE COALESCE(inUserUpdate, '')
          AND UD.table_name NOT ILIKE ('MovementItemContainer%')
          AND UD.table_name NOT ILIKE ('%Protocol')
          AND UD.table_name NOT ILIKE ('Container%')
          AND UD.table_name NOT ILIKE ('SoldTable')
          AND UD.table_name NOT ILIKE ('HistoryCost')
          AND (UD.table_name NOT ILIKE ('Movement%') OR COALESCE(Movement.ID, 0) <> 0)
        ORDER BY UD.ID;    
      END IF;
    END IF;
           
    IF EXISTS(SELECT 1
              FROM _replica.BranchService_Equalization_Id AS UD
              WHERE UD.ReplServerId = inReplServerId
              LIMIT 1)
    THEN   
      -- Получили дату и ID последней транзакции          
      SELECT MAX(UD.ID), MAX(UD.Last_Modified) 
      INTO vbId, vbDayeEnd
      FROM _replica.BranchService_Equalization_Id AS UD
      WHERE UD.ReplServerId = inReplServerId;
    ELSE
      vbId := inStartId;
      vbDayeEnd :=  timezone('utc'::text, CLOCK_TIMESTAMP()) - (inOffsetTime::TEXT||' MIN')::INTERVAL;
    END IF;
    
    -- Результат
    RETURN QUERY
    SELECT 1 AS Id
         , (select count(*)::Integer from _replica.BranchService_Equalization_Id AS UD WHERE UD.ReplServerId = inReplServerId) AS CountRecord
         , (select count(DISTINCT UD.Table_Name||UD.ValueId||'_'||UD.DescId)::Integer from _replica.BranchService_Equalization_Id AS UD WHERE UD.ReplServerId = inReplServerId) AS RowCount
         , COALESCE(vbId, inStartId)
         , vbDayeEnd;    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест
-- select * from _replica.gpBranchService_EqualizationPrepareId(1, '', '01.03.2022', 22247208873, 10000, 10, '0');