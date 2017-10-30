-- Function: gpInsertUpdate_Object_DataExcel_MCS_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DataExcel_MCS_From_Excel (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DataExcel_MCS_From_Excel(
    IN inUnitId     Integer, -- ID подразделение
    IN inGoodsCode  Integer, -- Code Товар
    IN inMCSValue   TFloat,  -- Неснижаемый товарный запас
    IN inSession    TVarChar -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbName        TVarChar;
    DECLARE vbUserId      Integer;
    DECLARE vbObjectId    Integer;
    DECLARE vbDataExcelId Integer;
    DECLARE vbGoodsId     Integer;
    DECLARE vbIndex       Integer;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    vbGoodsId := 0;
    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите подразделение';
    END IF;
    
    --поискали товар по коду
    SELECT Object_Goods.Id
           INTO vbGoodsId 
    FROM ObjectLink AS ObjectLink_Goods_Object
         INNER JOIN Object AS Object_Goods 
                           ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
                          AND Object_Goods.ObjectCode = inGoodsCode
    WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId;
                             
    --проверили, а есть ли такой товар в базе
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION 'Ошибка. В базе данных не найден товар с кодом <%>', inGoodsCode;
    END IF;
    
    IF inMCSValue is not null AND (inMCSValue < 0)
    THEN
        RAISE EXCEPTION 'Ошибка.Неснижаемый товарный запас <%> Не может быть меньше нуля.', inMCSValue;
    END IF;

    -- уже сохранненные данные
    SELECT Object_DataExcel.Id, Object_DataExcel.ValueData 
           INTO vbDataExcelId, vbName                             --STRING_AGG (Object_Unit.ValueData, '; ') AS UnitName
    FROM Object AS Object_DataExcel
         INNER JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_DataExcel.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                              AND ObjectLink_Insert.ChildObjectId = vbUserId
    WHERE Object_DataExcel.DescId = zc_Object_DataExcel()
        AND Object_DataExcel.ObjectCode = 1;
   
    -- таблица
    CREATE TEMP TABLE _tmpDataExcel (ValueData TVarChar, UnitId Integer, GoodsId Integer, MCSValue TFloat) ON COMMIT DROP;
    -- парсим данные, которые уже есть
    vbIndex := 1;
    WHILE SPLIT_PART (vbName, ';', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpDataExcel (ValueData) SELECT SPLIT_PART (vbName, ';', vbIndex) :: TVarChar;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;
    
    UPDATE _tmpDataExcel
     SET  UnitId   = CAST (zfCalc_Word_Split (inValue:= _tmpDataExcel.ValueData, inSep:= ',', inIndex:= 1) AS Integer)
        , GoodsId  = CAST (zfCalc_Word_Split (inValue:= _tmpDataExcel.ValueData, inSep:= ',', inIndex:= 2) AS Integer)
        , MCSValue = CAST (zfCalc_Word_Split (inValue:= _tmpDataExcel.ValueData, inSep:= ',', inIndex:= 3) AS TFloat);
        
    --обновляем значение НТЗ если уже такой товар был сохранен
    UPDATE _tmpDataExcel
     SET MCSValue = inMCSValue
    WHERE _tmpDataExcel.UnitId = inUnitId
      AND _tmpDataExcel.GoodsId = vbGoodsId;
      
    PERFORM lpInsertUpdate_Object_DataExcel(inId       := COALESCE (vbDataExcelId, 0) ::Integer,    -- ключ объекта <Элемент истории прайса>
                                            inCode     := 1,             -- 
                                            inName     := STRING_AGG (tmp.ValueData, '; '),
                                            inUserId   := vbUserId
                                            )
    FROM (SELECT (tmp.UnitId||','||tmp.GoodsId||','||tmp.MCSValue) :: TVarChar AS ValueData
          FROM _tmpDataExcel AS tmp
          WHERE tmp.UnitId = inUnitId
         UNION 
          SELECT (inUnitId||','||vbGoodsId||','||inMCSValue) :: TVarChar AS ValueData
          ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 30.10.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DataExcel_MCS_From_Excel()
