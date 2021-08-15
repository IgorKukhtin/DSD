-- Function: gpSelect_MovementItem_OrderInternalPromo_Export()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternalPromo_Export (Integer, Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternalPromo_Export(
    IN inMovementId   Integer      , -- ключ Документа
    IN inJuridicalId  Integer      , -- Поставщик
    IN inUnitCodeList Text         , -- Подразделения
    IN inSession      TVarChar       -- сессия пользователя
)

RETURNS SETOF refcursor 

AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;

  DECLARE vbQueryText   Text;
  DECLARE curUnit refcursor;
  DECLARE vbUnitId Integer;
  DECLARE vbIndex Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;


     -- Собираем что распределено по поставщику
     
     CREATE TEMP TABLE tmpOrderInternal ON COMMIT DROP AS
     (WITH tmpOrderInternalPromo AS (SELECT T1.Id
                                          , T1.GoodsId
                                          , T1.GoodsName
                                          , Object_Goods_Juridical.Code AS GoodsCode
                                          , T1.JuridicalName
                                          , T1.Price
                                          , ROW_NUMBER()OVER (PARTITION BY T1.Id ORDER BY Object_Goods_Juridical.Id) AS Ord
                                     FROM gpSelect_MI_OrderInternalPromo(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := inSession) AS T1
                                     
                                          INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = T1.GoodsId
                                          INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                                           AND Object_Goods_Juridical.JuridicalId = T1.JuridicalId

                                     WHERE T1.JuridicalId = inJuridicalId
                                       AND T1.Amount > 0)
     SELECT tmpOrderInternalPromo.Id
          , tmpOrderInternalPromo.GoodsId
          , tmpOrderInternalPromo.GoodsName
          , tmpOrderInternalPromo.GoodsCode
          , tmpOrderInternalPromo.JuridicalName
          , tmpOrderInternalPromo.Price
     FROM tmpOrderInternalPromo
     WHERE tmpOrderInternalPromo.Ord = 1
     ORDER BY tmpOrderInternalPromo.Id
     );

     IF NOT EXISTS(SELECT * FROM tmpOrderInternal)
     THEN
         RAISE EXCEPTION 'Нет данных для отправки.';
     END IF;


     -- Собираем что распределено по поставщику по аптекам

     CREATE TEMP TABLE tmpOrderInternalChild ON COMMIT DROP AS
     SELECT tmpOrderInternal.GoodsId
          ,  MovementItem.ObjectId AS UnitId
          ,  MovementItem.Amount
     
     FROM tmpOrderInternal 
          INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId = zc_MI_Child()
                                 AND MovementItem.isErased = FALSE
                                 AND MovementItem.ParentId = tmpOrderInternal.Id
                                 AND MovementItem.Amount > 0;
                                 
     -- Участвующие подразделения
     CREATE TEMP TABLE tmpUnit (ID           Integer
                              , UnitId       Integer
                              , FieldName    TVarChar
                              , DisplayName  TVarChar
                              , Width        Integer) ON COMMIT DROP;


     -- парсим подразделения
     vbIndex := 1;
     WHILE SPLIT_PART (inUnitCodeList, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO tmpUnit (Id, UnitId, FieldName, DisplayName, Width)
         SELECT vbIndex
              , Object_Unit.Id
              , ('Amount'||vbIndex::TVarChar)::TVarChar                           AS FieldName
              , (Object_Unit.ValueData||' ('||Object_Juridical.ValueData||' '||
                COALESCE(ObjectHistory_JuridicalDetails.OKPO, '')||')')::TVarChar AS DisplayName
              , 100 AS Width 
         FROM Object AS Object_Unit 
         
              LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.ID = ObjectLink_Unit_Juridical.ChildObjectId
                                  
              LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_Unit_Juridical.ChildObjectId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
         WHERE Object_Unit.DescID = zc_Object_Unit()
           AND Object_Unit.ObjectCode = SPLIT_PART (inUnitCodeList, ',', vbIndex) :: Integer;

        -- теперь следуюющий
        vbIndex := vbIndex + 1;
     END LOOP;
     
     raise notice 'Value 03: %', (SELECT count(*) FROM tmpUnit);
                                 
     -- Заполняем данными
     vbIndex := 1;
     OPEN curUnit FOR
     SELECT tmpUnit.UnitId
     FROM tmpUnit 
     ORDER BY tmpUnit.Id;

     -- начало цикла по курсору1
     LOOP
        -- данные по курсору1
        FETCH curUnit INTO vbUnitId;
        -- если данные закончились, тогда выход
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpOrderInternal ADD COLUMN Amount' || COALESCE (vbIndex, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpOrderInternal SET Amount' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.Amount, 0) ' ||
                       ' FROM (SELECT tmpOrderInternalChild.GoodsId, SUM(tmpOrderInternalChild.Amount) AS Amount 
                               FROM tmpOrderInternalChild WHERE tmpOrderInternalChild.UnitId = '|| vbUnitId::Text ||' GROUP BY tmpOrderInternalChild.GoodsId) AS T1'||
                       ' WHERE tmpOrderInternal.GoodsId = T1.GoodsId';
        EXECUTE vbQueryText;

        vbIndex := vbIndex + 1;
     END LOOP; -- финиш цикла по курсору1
     CLOSE curUnit; -- закрыли курсор1
     
     -- Добавляем итого
     
     ALTER TABLE tmpOrderInternal ADD COLUMN Amount TFloat NOT NULL DEFAULT 0;     
     
     UPDATE tmpOrderInternal SET Amount = COALESCE (T1.Amount, 0)
     FROM (SELECT tmpOrderInternalChild.GoodsId, SUM(tmpOrderInternalChild.Amount) AS Amount 
           FROM tmpOrderInternalChild  
           GROUP BY tmpOrderInternalChild.GoodsId) AS T1
     WHERE tmpOrderInternal.GoodsId = T1.GoodsId;
     
     OPEN Cursor1 FOR
     SELECT 'GoodsName'::TVarChar  AS FieldName
          , ' '::TVarChar AS DisplayName
          , 100 AS Width 
     UNION ALL
     SELECT 'GoodsCode'::TVarChar  AS FieldName
          , ' '::TVarChar AS DisplayName
          , 100 AS Width 
     UNION ALL
     SELECT 'JuridicalName'::TVarChar AS FieldName
          , ' '::TVarChar AS DisplayName
          , 100 AS Width 
     UNION ALL
     SELECT 'Price'::TVarChar  AS FieldName
          , ' '::TVarChar AS DisplayName
          , 100 AS Width 
     UNION ALL (
     SELECT tmpUnit.FieldName
          , tmpUnit.DisplayName
          , tmpUnit.Width 
     FROM tmpUnit 
     ORDER BY tmpUnit.ID)
     UNION ALL
     SELECT 'Amount'::TVarChar AS FieldName
          , 'Итого'::TVarChar AS DisplayName
          , 100 AS Width 
          
     ;

     RETURN NEXT Cursor1;
     
     ALTER TABLE tmpOrderInternal DROP COLUMN Id;
     
     ALTER TABLE tmpOrderInternal DROP COLUMN GoodsId;

     OPEN Cursor2 FOR
     SELECT *
     FROM tmpOrderInternal;

     RETURN NEXT Cursor2;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternalPromo_Export (Integer, Integer, Text, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.08.21                                                       *

*/

-- тест
-- 
select * from gpSelect_MovementItem_OrderInternalPromo_Export(inMovementId := 24178054 , inJuridicalId := 59610 , inUnitCodeList := '13,14,15,74,11,29,34,57,104' ,  inSession := '3');