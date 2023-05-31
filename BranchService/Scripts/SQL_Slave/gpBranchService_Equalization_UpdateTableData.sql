-- Function: gpBranchService_Equalization_UpdateTableData (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Equalization_UpdateTableData (Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Equalization_UpdateTableData(
    IN inReplServerId           Integer ,    -- Сервер репликации
    IN inTableName              Text    ,    -- Таблица
    IN inSession                TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, RowCount Integer) 
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
   
   DECLARE vbQueryText TEXT;
   DECLARE vbRowCount  Integer; 

   DECLARE vbColumn_Name_List      TEXT;
   DECLARE vbColumn_Name_Master    TEXT;
   DECLARE vbColumn_Name_Select    TEXT;
   DECLARE vbColumn_Name_Type      TEXT;
   DECLARE vbColumn_Name_Order     TEXT;
   DECLARE vbColumn_Name_Update    TEXT;   

   DECLARE vbMovementDescAll       Text;
   DECLARE vbMovementDesc          Text;
   
   DECLARE vbOn                    TEXT;   
   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   vbRowCount := 0;

   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);
   
   -- Готовим данные для запроса
   WITH tmpIndexes AS (SELECT string_to_array(SUBSTRING(i.indexdef, POSITION('(' IN i.indexdef) + 1, length(i.indexdef) - POSITION('(' IN i.indexdef) - 1), ', ') AS Columns
                       FROM pg_indexes i 
                       WHERE i.tablename ILIKE inTableName 
                         AND (i.indexname ILIKE '%_pkey' OR i.indexname ILIKE 'pk_%')
                       LIMIT 1)

   SELECT string_agg(c.column_name::Text, ', ')                                    AS Column_Name_List
        , string_agg('q.'||c.column_name::Text, ', ')                              AS Column_Name_Select
        , string_agg(inTableName||'.'||c.column_name::Text, ', ')                  AS Column_Name_Master
        , string_agg(c.column_name::Text||' '||udt_name::Text, ', ')               AS Column_Name_Type
        , string_agg(CASE WHEN tmpIndexes.Columns && Array[c.column_name::Text] 
                          THEN c.column_name::Text END, ', ')                      AS Column_Name_Order
        , string_agg(CASE WHEN not tmpIndexes.Columns && Array[c.column_name::Text] 
                          THEN c.column_name::Text||' = EXCLUDED.'||c.column_name::Text END, ', ') AS Column_Name_Update
   INTO vbColumn_Name_List
      , vbColumn_Name_Select
      , vbColumn_Name_Master
      , vbColumn_Name_Type
      , vbColumn_Name_Order
      , vbColumn_Name_Update
   FROM information_schema.columns c 
       
        LEFT JOIN tmpIndexes ON 1 = 1 
            
   WHERE c.table_catalog = current_database()
     AND c.table_name ILIKE inTableName;  
     
   -- Создаем ON
   IF SPLIT_PART (vbColumn_Name_Order, ', ', 2) <> '' 
   THEN
   
     IF SPLIT_PART (vbColumn_Name_Order, ', ', 1) ILIKE 'DescId' 
     THEN
       vbOn := inTableName||'.'||SPLIT_PART (vbColumn_Name_Order, ',', 1)||' = EI.DescId'||' AND '||
               inTableName||'.'||SPLIT_PART (vbColumn_Name_Order, ',', 2)||' = EI.ValueId';
     ELSE
       vbOn := inTableName||'.'||SPLIT_PART (vbColumn_Name_Order, ',', 1)||' = EI.ValueId'||' AND '||
               inTableName||'.'||SPLIT_PART (vbColumn_Name_Order, ',', 2)||' = EI.DescId';
     END IF;
     
   ELSE 
      vbOn := inTableName||'.'||SPLIT_PART (vbColumn_Name_Order, ',', 1)||' = EI.ValueId';
   END IF;        
   
     -- Обновляем данные таблицы

   IF  inTableName ILIKE 'Movement'
   THEN
     SELECT string_agg(MovementDesc.Code||'()', ',')
     INTO vbMovementDescAll
     FROM _replica.BranchService_DescId_Movement AS DM
          INNER JOIN MovementDesc ON MovementDesc.Id = DM.DescId; 

     SELECT string_agg(MovementDesc.Code||'()', ',')
     INTO vbMovementDesc
     FROM _replica.BranchService_DescId_Movement AS DM
          INNER JOIN MovementDesc ON MovementDesc.Id = DM.DescId
     WHERE DM.isEqualization = True; 

     vbQueryText := 'WITH ins AS ('||
                    'INSERT INTO '||inTableName||' ('||vbColumn_Name_List||') '||
                    'SELECT '||vbColumn_Name_Select||' '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'WITH tmpEI AS (SELECT EI.ValueId '|| 
                                 '                     , EI.DescId '|| 
                                 '                     , SUM(CASE WHEN EI.isInsert THEN 1 ELSE 0 END) > 0 AS isInsert '|| 
                                 '               FROM _replica.BranchService_Equalization_Id AS EI '||
                                 '               WHERE EI.ReplServerId = '||inReplServerId::TEXT||' '|| 
                                 '               AND EI.Table_Name ILIKE '''''||inTableName||''''' '||
                                 '               GROUP BY EI.ValueId, EI.DescId) '||
                                 'SELECT '||vbColumn_Name_Master||', EI.isInsert '|| 
                                 'FROM tmpEI AS EI '||
                                 '   INNER JOIN '||inTableName||' ON '||vbOn||' '||
                                 '                 AND '||inTableName||'.DescId IN ('||vbMovementDescAll||') '||
                                 'ORDER BY '||vbColumn_Name_Order||';''::text) AS '||
                                 'q('||vbColumn_Name_Type||', isInsert Boolean) '||
                                 '   LEFT JOIN Movement ON Movement.Id = q.Id ' ||
                                 'WHERE COALESCE(Movement.Id, 0) <> 0 OR q.isInsert = TRUE AND q.DescId IN ('||vbMovementDesc||') '||
                    'ON CONFLICT ('||vbColumn_Name_Order||') DO UPDATE SET '||vbColumn_Name_Update||' '||
                    'RETURNING '||vbColumn_Name_Order||' '||
                    ') SELECT Count(*) AS RowCount FROM ins';         
            
   ELSEIF (inTableName ILIKE 'Movement%' AND inTableName NOT ILIKE 'MovementItem%' OR inTableName ILIKE 'MovementItem') AND inTableName NOT ILIKE '%Desc' 
   THEN
     
     vbQueryText := 'WITH ins AS ('||
                    'INSERT INTO '||inTableName||' ('||vbColumn_Name_List||') '||
                    'SELECT '||vbColumn_Name_Select||' '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'WITH tmpEI AS (SELECT DISTINCT EI.ValueId, EI.DescId '|| 
                                 '               FROM _replica.BranchService_Equalization_Id AS EI '||
                                 '               WHERE EI.ReplServerId = '||inReplServerId::TEXT||' '|| 
                                 '               AND EI.Table_Name ILIKE '''''||inTableName||''''') '||
                                 'SELECT '||vbColumn_Name_Master||' '|| 
                                 'FROM tmpEI AS EI '||
                                 '   INNER JOIN '||inTableName||' ON '||vbOn||' '||
                                 'ORDER BY '||vbColumn_Name_Order||';''::text) AS '||
                                 'q('||vbColumn_Name_Type||') '||
                                 '   INNER JOIN Movement ON Movement.Id = q.MovementId ' ||
                    'ON CONFLICT ('||vbColumn_Name_Order||') DO UPDATE SET '||vbColumn_Name_Update||' '||
                    'RETURNING '||vbColumn_Name_Order||' '||
                    ') SELECT Count(*) AS RowCount FROM ins';         

   ELSEIF inTableName ILIKE 'MovementItem%' AND inTableName NOT ILIKE '%Desc' 
   THEN
     
     vbQueryText := 'WITH ins AS ('||
                    'INSERT INTO '||inTableName||' ('||vbColumn_Name_List||') '||
                    'SELECT '||vbColumn_Name_Select||' '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'WITH tmpEI AS (SELECT DISTINCT EI.ValueId, EI.DescId '|| 
                                 '               FROM _replica.BranchService_Equalization_Id AS EI '||
                                 '               WHERE EI.ReplServerId = '||inReplServerId::TEXT||' '|| 
                                 '               AND EI.Table_Name ILIKE '''''||inTableName||''''') '||
                                 'SELECT '||vbColumn_Name_Master||' '|| 
                                 'FROM tmpEI AS EI '||
                                 '   INNER JOIN '||inTableName||' ON '||vbOn||' '||
                                 'ORDER BY '||vbColumn_Name_Order||';''::text) AS '||
                                 'q('||vbColumn_Name_Type||') '||
                                 '   INNER JOIN MovementItem ON MovementItem.Id = q.MovementItemId ' ||
                    'ON CONFLICT ('||vbColumn_Name_Order||') DO UPDATE SET '||vbColumn_Name_Update||' '||
                    'RETURNING '||vbColumn_Name_Order||' '||
                    ') SELECT Count(*) AS RowCount FROM ins';         

   ELSEIF inTableName ILIKE 'ObjectBlob' 
   THEN

     vbQueryText := 'WITH ins AS ('||
                    'INSERT INTO '||inTableName||' ('||vbColumn_Name_List||') '||
                    'SELECT '||vbColumn_Name_Select||' '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'WITH tmpEI AS (SELECT DISTINCT EI.ValueId, EI.DescId '|| 
                                 '               FROM _replica.BranchService_Equalization_Id AS EI '||
                                 '               WHERE EI.ReplServerId = '||inReplServerId::TEXT||' '|| 
                                 '               AND EI.Table_Name ILIKE '''''||inTableName||''''') '||
                                 'SELECT '||vbColumn_Name_Master||' '|| 
                                 'FROM tmpEI AS EI '||
                                 '   INNER JOIN '||inTableName||' ON '||vbOn||' '||
                                 'WHERE EI.DescId NOT IN (zc_ObjectBlob_ContractDocument_Data(), zc_ObjectBlob_PhotoMobile_Data()) '||
                                 'ORDER BY '||vbColumn_Name_Order||';''::text) AS '||
                                 'q('||vbColumn_Name_Type||') '||
                    'ON CONFLICT ('||vbColumn_Name_Order||') DO UPDATE SET '||vbColumn_Name_Update||' '||
                    'RETURNING '||vbColumn_Name_Order||' '||
                    ') SELECT Count(*) AS RowCount FROM ins';         

   ELSEIF inTableName ILIKE 'ObjectBlob' 
   THEN

     vbQueryText := 'WITH ins AS ('||
                    'INSERT INTO '||inTableName||' ('||vbColumn_Name_List||') '||
                    'SELECT '||vbColumn_Name_Select||' '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'WITH tmpEI AS (SELECT DISTINCT EI.ValueId, EI.DescId '|| 
                                 '               FROM _replica.BranchService_Equalization_Id AS EI '||
                                 '               WHERE EI.ReplServerId = '||inReplServerId::TEXT||' '|| 
                                 '               AND EI.Table_Name ILIKE '''''||inTableName||''''') '||
                                 'SELECT '||vbColumn_Name_Master||' '|| 
                                 'FROM tmpEI AS EI '||
                                 '   INNER JOIN '||inTableName||' ON '||vbOn||' '||
                                 'WHERE EI.DescId NOT IN (zc_ObjectBlob_ContractDocument_Data(), zc_ObjectBlob_PhotoMobile_Data()) '||
                                 'ORDER BY '||vbColumn_Name_Order||';''::text) AS '||
                                 'q('||vbColumn_Name_Type||') '||
                    'ON CONFLICT ('||vbColumn_Name_Order||') DO UPDATE SET '||vbColumn_Name_Update||' '||
                    'RETURNING '||vbColumn_Name_Order||' '||
                    ') SELECT Count(*) AS RowCount FROM ins';         
   ELSE
          
     vbQueryText := 'WITH ins AS ('||
                    'INSERT INTO '||inTableName||' ('||vbColumn_Name_List||') '||
                    'SELECT '||vbColumn_Name_Select||' '||
                    'FROM dblink(''host='||vbHost||
                                  ' dbname='||vbDBName||
                                  ' port='||vbPort::Text|| 
                                  ' user='||vbUserName||
                                  ' password='||vbPassword||'''::text,'''|| 
                                 'WITH tmpEI AS (SELECT DISTINCT EI.ValueId, EI.DescId '|| 
                                 '               FROM _replica.BranchService_Equalization_Id AS EI '||
                                 '               WHERE EI.ReplServerId = '||inReplServerId::TEXT||' '|| 
                                 '               AND EI.Table_Name ILIKE '''''||inTableName||''''') '||
                                 'SELECT '||vbColumn_Name_Master||' '|| 
                                 'FROM tmpEI AS EI '||
                                 '   INNER JOIN '||inTableName||' ON '||vbOn||' '||
                                 'ORDER BY '||vbColumn_Name_Order||';''::text) AS '||
                                 'q('||vbColumn_Name_Type||') '||
                    'ON CONFLICT ('||vbColumn_Name_Order||') DO UPDATE SET '||vbColumn_Name_Update||' '||
                    'RETURNING '||vbColumn_Name_Order||' '||
                    ') SELECT Count(*) AS RowCount FROM ins';         
                    
   END IF;

   --raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbQueryText;               
     
   IF COALESCE (vbQueryText, '') <> ''
   THEN
     EXECUTE vbQueryText INTO vbRowCount;
   END IF;
     
      -- Результат
   RETURN QUERY
   SELECT 1 AS Id, COALESCE(vbRowCount, 0) AS RowCount;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест

-- 
select * from _replica.gpBranchService_Equalization_UpdateTableData(7817268, 'ObjectBlob', '0');