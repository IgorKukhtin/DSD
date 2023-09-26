-- Function: gpSelect_Slave_MovementProperties (BIGINT, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpSelect_Slave_MovementProperties (BIGINT, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Slave_MovementProperties(
    IN inTransaction_Id  BIGINT ,
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (Table_Name TVarChar
             , ValueId Integer
             , DescId Integer
             , ValueData TEXT
              ) 
AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
  vbUserId:= inSession::Integer;

  -- Результат
  RETURN QUERY
  WITH UD AS (SELECT UD.Table_Name
                   , CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                          THEN CASE WHEN (string_to_array(SUBSTRING(UD.pk_keys, 2, length(UD.pk_keys) - 2), ', '))[1] ILIKE 'DescID'
                                    THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[2] 
                                    ELSE (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[1]  END
                          ELSE UD.pk_values END::Integer      AS ValueId
                   , CASE WHEN SUBSTRING(UD.pk_values, 1, 1) = '{' 
                          THEN CASE WHEN (string_to_array(SUBSTRING(UD.pk_keys, 2, length(UD.pk_keys) - 2), ', '))[1] ILIKE 'DescID'
                                    THEN (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[1] 
                                    ELSE (string_to_array(SUBSTRING(UD.pk_values, 2, length(UD.pk_values) - 2), ', '))[2]  END
                          ELSE Null END::Integer              AS DescId                   
              FROM _replica.table_update_data AS UD
              WHERE UD.Transaction_Id = inTransaction_Id
                AND UD.Table_Name ILIKE 'Movement%'
                AND UD.Table_Name NOT ILIKE 'Movement'
                AND UD.Table_Name NOT ILIKE 'MovementItem'
                AND UD.Table_Name NOT ILIKE 'MovementItemContainer%'
                AND UD.Table_Name NOT ILIKE '%Protocol%'
              )

  SELECT UD.Table_Name::TVarChar
       , UD.ValueId
       , UD.DescId
       , COALESCE(MovementBLOB.ValueData::TEXT, 
                  MovementBoolean.ValueData::TEXT, 
                  MovementDate.ValueData::TEXT, 
                  MovementFloat.ValueData::TEXT, 
                  MovementString.ValueData::TEXT, 
                  MovementLinkMovement.MovementChildId::TEXT, 
                  MovementLinkObject.ObjectId::TEXT, 
                  MovementItemBoolean.ValueData::TEXT,                 
                  MovementItemDate.ValueData::TEXT, 
                  MovementItemFloat.ValueData::TEXT, 
                  MovementItemString.ValueData::TEXT, 
                  MovementItemLinkObject.ObjectId::TEXT, 
                  Null::TEXT)  AS ValueData 
  FROM UD
       
       LEFT JOIN MovementBLOB ON UD.Table_Name ILIKE 'MovementBLOB'
                             AND MovementBLOB.MovementId = UD.ValueId
                             AND MovementBLOB.DescId = UD.DescId

       LEFT JOIN MovementBoolean ON UD.Table_Name ILIKE 'MovementBoolean'
                                AND MovementBoolean.MovementId = UD.ValueId
                                AND MovementBoolean.DescId = UD.DescId

       LEFT JOIN MovementDate ON UD.Table_Name ILIKE 'MovementDate'
                             AND MovementDate.MovementId = UD.ValueId
                             AND MovementDate.DescId = UD.DescId

       LEFT JOIN MovementFloat ON UD.Table_Name ILIKE 'MovementFloat'
                              AND MovementFloat.MovementId = UD.ValueId
                              AND MovementFloat.DescId = UD.DescId

       LEFT JOIN MovementString ON UD.Table_Name ILIKE 'MovementString'
                               AND MovementString.MovementId = UD.ValueId
                               AND MovementString.DescId = UD.DescId

       LEFT JOIN MovementLinkMovement ON UD.Table_Name ILIKE 'MovementLinkMovement'
                                     AND MovementLinkMovement.MovementId = UD.ValueId
                                     AND MovementLinkMovement.DescId = UD.DescId

       LEFT JOIN MovementLinkObject ON UD.Table_Name ILIKE 'MovementLinkObject'
                                   AND MovementLinkObject.MovementId = UD.ValueId
                                   AND MovementLinkObject.DescId = UD.DescId

       LEFT JOIN MovementItemBoolean ON UD.Table_Name ILIKE 'MovementItemBoolean'
                                    AND MovementItemBoolean.MovementItemId = UD.ValueId
                                    AND MovementItemBoolean.DescId = UD.DescId

       LEFT JOIN MovementItemDate ON UD.Table_Name ILIKE 'MovementItemDate'
                                 AND MovementItemDate.MovementItemId = UD.ValueId
                                 AND MovementItemDate.DescId = UD.DescId

       LEFT JOIN MovementItemFloat ON UD.Table_Name ILIKE 'MovementItemFloat'
                                  AND MovementItemFloat.MovementItemId = UD.ValueId
                                  AND MovementItemFloat.DescId = UD.DescId

       LEFT JOIN MovementItemString ON UD.Table_Name ILIKE 'MovementItemString'
                                   AND MovementItemString.MovementItemId = UD.ValueId
                                   AND MovementItemString.DescId = UD.DescId

       LEFT JOIN MovementItemLinkObject ON UD.Table_Name ILIKE 'MovementItemLinkObject'
                                       AND MovementItemLinkObject.MovementItemId = UD.ValueId
                                       AND MovementItemLinkObject.DescId = UD.DescId
  ;
                                     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.09.23                                                       * 
*/

-- Тест

-- select * from _replica.gpSelect_Slave_MovementProperties(inTransaction_Id := 14959432, inSession:= zfCalc_UserAdmin());  