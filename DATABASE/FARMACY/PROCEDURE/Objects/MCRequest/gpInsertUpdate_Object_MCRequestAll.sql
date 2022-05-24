-- Function: gpInsertUpdate_Object_MCRequestAll()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MCRequestAll(Text, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MCRequestAll(
    IN inJson            Text      , -- json Данные    
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMCRequesId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF inJson = '[]'
  THEN
    RAISE EXCEPTION 'Данные с базы не загружены.';
  END IF;

  
  -- из JSON в таблицу
  CREATE TEMP TABLE tblDataJSON
  (
     MinPrice           TFloat,
     MarginPercentCurr  TFloat,
     MarginPercent      TFloat
  ) ON COMMIT DROP;

  INSERT INTO tblDataJSON
  SELECT *
  FROM json_populate_recordset(null::tblDataJSON, replace(replace(replace(inJson, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
  
  IF NOT EXISTS (SELECT * FROM tblDataJSON WHERE tblDataJSON.MarginPercentCurr <> tblDataJSON.MarginPercent)
  THEN
    RAISE EXCEPTION 'Новые прценты наценок совпадают с текущими.';
  END IF;

  IF NOT EXISTS (SELECT 1
                 FROM Object AS Object_MCReques
                 WHERE Object_MCReques.DescId = zc_Object_MCRequest()
                   AND Object_MCReques.ObjectCode = 1)
  THEN
    vbMCRequesId := gpInsertUpdate_Object_MCRequest(0, 1, 'Запрос на изменение категории наценки по сети', inSession);
  ELSE 
    SELECT Object_MCReques.Id
    INTO vbMCRequesId
    FROM Object AS Object_MCReques
    WHERE Object_MCReques.DescId = zc_Object_MCRequest()
      AND Object_MCReques.ObjectCode = 1;
  END IF;
  
  PERFORM gpInsertUpdate_Object_MCRequestItem(ioId                := T1.MCRequestItemId
                                            , inMCRequestId       := vbMCRequesId
                                            , inMinPrice          := T1.MinPrice
                                            , inMarginPercentOld  := T1.MarginPercentCurr
                                            , inMarginPercent     := T1.MarginPercent
                                            , inSession           := inSession)
  FROM (
      WITH tmpData AS (SELECT tblDataJSON.MinPrice
                            , tblDataJSON.MarginPercentCurr 
                            , tblDataJSON.MarginPercent
                            , ROW_NUMBER() OVER (ORDER BY tblDataJSON.MinPrice) AS Ord
                       FROM tblDataJSON)
        , tmpMCRequest AS (SELECT ObjectLink_MCRequest.ObjectId         AS MCRequestItemId
                                , ObjectFloat_MinPrice.ValueData        AS MinPrice
                                , ObjectFloat_MarginPercent.ValueData   AS MarginPercent
                                , ROW_NUMBER() OVER (ORDER BY ObjectFloat_MinPrice.ValueData) AS Ord                                         
                           FROM Object AS Object_MCReques 

                                LEFT JOIN ObjectLink AS ObjectLink_MCRequest
                                                     ON ObjectLink_MCRequest.ChildObjectId = Object_MCReques.Id
                                                    AND ObjectLink_MCRequest.DescId = zc_ObjectLink_MCRequestItem_MCRequest()
                                                                                         
                                LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                      ON ObjectFloat_MinPrice.ObjectId = ObjectLink_MCRequest.ObjectId
                                                     AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MCRequestItem_MinPrice()
                                LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                                      ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MCRequest.ObjectId
                                                     AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MCRequestItem_MarginPercent()

                           WHERE Object_MCReques.DescId = zc_Object_MCRequest()
                             AND Object_MCReques.Id = vbMCRequesId)
                           
        SELECT COALESCE (tmpMCRequest.MCRequestItemId, 0)         AS MCRequestItemId
             , COALESCE (tmpData.MarginPercentCurr, 0)            AS MarginPercentCurr
             , COALESCE (tmpData.MinPrice, tmpMCRequest.MinPrice) AS MinPrice
             , COALESCE (tmpData.MarginPercent, 0)                AS MarginPercent
        FROM tmpData 
        
             FULL JOIN tmpMCRequest ON tmpMCRequest.Ord = tmpData.Ord
             
        ) AS T1;

    -- сохранили Дату изменения
    PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_MCRequest_DateUpdate(), vbMCRequesId, CURRENT_TIMESTAMP);
    -- очистили Дату сравнения
    PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_MCRequest_DateDone(), vbMCRequesId, Null);

    --RAISE EXCEPTION '% %', (SELECT COUNT (*) FROM tblDataJSON WHERE tblDataJSON.MarginPercentCurr <> tblDataJSON.MarginPercent), vbMCRequesId;
                             
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 20.05.22                                                                    *
*/

-- тест 

select * from gpInsertUpdate_Object_MCRequestAll(inJson := '[{"minprice":0,"marginpercentcurr":18,"marginpercent":18},{"minprice":100,"marginpercentcurr":14,"marginpercent":12},{"minprice":250,"marginpercentcurr":13,"marginpercent":13},{"minprice":350,"marginpercentcurr":14,"marginpercent":14},{"minprice":500,"marginpercentcurr":12,"marginpercent":12},{"minprice":1000,"marginpercentcurr":9,"marginpercent":9},{"minprice":2000,"marginpercentcurr":9,"marginpercent":9}]' ,  inSession := '3');