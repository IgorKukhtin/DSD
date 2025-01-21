-- Function: gpSelect_Object_GlobalConst()

-- DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConst (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConst(
    IN inIP          TVarChar,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, ValueText TVarChar, EnumName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbValueData_new TVarChar;
   DECLARE vbOperDate_new TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- если Кто - то запустил эти отчеты - отключим его :)
     IF EXISTS (SELECT 1
                FROM gpSelect_Object_ReportExternal (inSession:= zfCalc_UserAdmin()) AS gpSelect
                     JOIN pg_stat_activity AS pg_PROC ON pg_PROC.state = 'active' AND pg_PROC.query_start < CURRENT_TIMESTAMP - INTERVAL '1 MIN'
                                                     AND LOWER (pg_PROC.query) LIKE LOWER ('%' || gpSelect.Name ||'(%')
               )
     -- AND vbUserId = zfCalc_UserAdmin() :: Integer
        AND 1=0
 
     THEN -- !!! ОТКЛЮЧИЛИ !!!
          PERFORM pg_cancel_backend (tmp.pId)
          FROM (SELECT pg_PROC.pId
                FROM gpSelect_Object_ReportExternal (inSession:= zfCalc_UserAdmin()) AS gpSelect
                     JOIN pg_stat_activity AS pg_PROC ON pg_PROC.state = 'active' AND pg_PROC.query_start < CURRENT_TIMESTAMP - INTERVAL '1 SEC'
                                                     AND LOWER (pg_PROC.query) LIKE LOWER ('%' || gpSelect.Name ||'(%')
                WHERE gpSelect.Name ILIKE '%Mobile%'
               ) AS tmp;
     END IF;

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!
     PERFORM  pg_terminate_backend(a.pid)
            , pg_cancel_backend(a.pId)
     FROM pg_stat_activity AS a WHERE a.state = 'active' AND ((a.query ILIKE '%gpGet_Movement_Sale%'     AND a.query_start < CURRENT_TIMESTAMP - INTERVAL '5 MIN')
                                                           OR (a.query ILIKE 'select * from gpExecSql(%' AND a.query_start < CURRENT_TIMESTAMP - INTERVAL '5 MIN'))
     ;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!
-- perform pg_terminate_backend(a.pid)
-- FROM pg_stat_activity as a where a.state <> 'active' AND a.query_start < CURRENT_TIMESTAMP - INTERVAL '24 HOURS';

     -- если Пользователь "на связи" запишем что он "Работает"
     PERFORM lpInsert_LoginProtocol (inUserLogin  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId)
                                   , inIP         := inIP
                                   , inUserId     := vbUserId
                                   , inIsConnect  := FALSE
                                   , inIsProcess  := TRUE
                                   , inIsExit     := FALSE
                                    );


     -- только Админ делает Update
     /*IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         CREATE TEMP TABLE _tmpMovement (MovementId Integer, DescId Integer, InvNumber TVarChar, OperDate TDateTime) ON COMMIT DROP;
         INSERT INTO _tmpMovement (MovementId, DescId, InvNumber, OperDate)
            SELECT Movement.Id, Movement.DescId, Movement.InvNumber, Movement.OperDate
            FROM Movement
            WHERE Movement.OperDate >= '01.07.2015'
            AND Movement.StatusId = zc_Enum_Status_UnComplete()
            AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_Inventory(), zc_Movement_Loss(), zc_Movement_ProductionSeparate(), zc_Movement_ProductionUnion(), zc_Movement_ReturnIn(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_Send(), zc_Movement_SendOnPrice())
            ORDER BY Movement.OperDate
            LIMIT 100;
         --
         SELECT ' ' || COALESCE (Object_User.ValueData, '') || ' <' || TO_CHAR (COALESCE (MovementProtocol.OperDate, MovementProtocol_arc.OperDate), 'DD.MM HH24:MM') || '> документ <' || MovementDesc.ItemName || '>  № <' || tmp.InvNumber || '> Актуальность отчетов до:'
              , tmp.OperDate
                INTO vbValueData_new, vbOperDate_new
         FROM (SELECT _tmpMovement.MovementId, _tmpMovement.DescId, _tmpMovement.InvNumber, _tmpMovement.OperDate, MAX (MovementProtocol_arc.Id) AS Id_find_arc, MAX (MovementProtocol.Id) AS Id_find
               FROM _tmpMovement
                    LEFT JOIN MovementProtocol_arc ON MovementProtocol_arc.MovementId = _tmpMovement.MovementId
                                                  AND MovementProtocol_arc.OperDate < CURRENT_TIMESTAMP - INTERVAL '3 MINUTE'
                    LEFT JOIN MovementProtocol ON MovementProtocol.MovementId = _tmpMovement.MovementId
                                              AND MovementProtocol.OperDate < CURRENT_TIMESTAMP - INTERVAL '3 MINUTE'
               GROUP BY _tmpMovement.MovementId, _tmpMovement.DescId, _tmpMovement.InvNumber, _tmpMovement.OperDate
              ) AS tmp
              LEFT JOIN MovementProtocol_arc ON MovementProtocol_arc.Id = tmp.Id_find_arc
              LEFT JOIN MovementProtocol ON MovementProtocol.Id = tmp.Id_find
              LEFT JOIN Object AS Object_User ON Object_User.Id = COALESCE (MovementProtocol.UserId, MovementProtocol_arc.UserId)
              LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.DescId
         WHERE tmp.Id_find_arc > 0 OR tmp.Id_find > 0
         ORDER BY tmp.OperDate
         LIMIT 1;

         --
         --
         UPDATE Object SET ValueData = COALESCE (vbValueData_new, 'Актуальность 100 %')
         WHERE Object.Id = 418996 -- актуальность данных Integer
           AND Object.DescId = zc_Object_GlobalConst();
         --
         UPDATE ObjectDate SET ValueData = COALESCE (vbOperDate_new, CURRENT_TIMESTAMP)
         WHERE ObjectDate.ObjectId = 418996 -- актуальность данных Integer
           AND ObjectDate.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement();
     END IF;*/


     -- Результат
     RETURN QUERY
       WITH tmpProcess AS (SELECT * FROM pg_stat_activity WHERE state = 'active' /*and UseName = 'postgres'*/)
          , tmpProcess_All AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess)
          , tmpProcess_HistoryCost AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpInsertUpdate_HistoryCost%' OR query LIKE '%gpComplete_All_Sybase%')
          , tmpProcess_Exp AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Scale%')
          , tmpProcess_Inv AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Inventory%')
          , tmpProcess_Rep1 AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpReport_GoodsMI_SaleReturnIn%')
          , tmpProcess_Rep2 AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpReport_MotionGoods%')
          , tmpProcess_Rep3 AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpReport_GoodsBalance%')
          , tmpProcess_RepOth AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpReport%' AND query NOT LIKE '%gpReport_GoodsMI_SaleReturnIn%'
                                                                                                        AND query NOT LIKE '%gpReport_MotionGoods%'
                                                                                                        AND query NOT LIKE '%gpReport_GoodsBalance%'
                                 )
          , tmpProcess_Vacuum AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%VACUUM%')
          , tmpProcess_Waiting AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE waiting = TRUE)
          , tmpProcess_Time1 AS (SELECT Query_start FROM tmpProcess ORDER BY Query_start ASC LIMIT 1)
          , tmpProcess_Time2 AS (SELECT Query_start FROM tmpProcess WHERE Query_start > (SELECT Query_start FROM tmpProcess_Time1) ORDER BY Query_start ASC LIMIT 1)
          , tmpProcess_Time3 AS (SELECT Query_start FROM tmpProcess WHERE Query_start > (SELECT Query_start FROM tmpProcess_Time2) ORDER BY Query_start ASC LIMIT 1)
       -- Результат
       SELECT Object_GlobalConst.Id
            , CASE WHEN Object_GlobalConst.Id = 418996 -- актуальность данных Integer
                        THEN CURRENT_TIMESTAMP -- CURRENT_TIME
                   ELSE COALESCE (ActualBankStatement.ValueData, CASE WHEN Object_GlobalConst.Id = zc_Enum_GlobalConst_PeriodClosePlan() THEN NULL ELSE CURRENT_DATE END)
              END :: TDateTime AS OperDate
            , CASE WHEN Object_GlobalConst.Id = zc_Enum_GlobalConst_PeriodClosePlan()
                        THEN 'План закрытия периода за ' || zfCalc_MonthName (COALESCE ((SELECT OD.ValueData
                                                                                         FROM ObjectDate AS OD
                                                                                         WHERE OD.ObjectId = zc_Enum_GlobalConst_StartDate_Auto_PrimeCost()
                                                                                           AND OD.DescId   = zc_ObjectDate_GlobalConst_ActualBankStatement()
                                                                                        ), ActualBankStatement.ValueData - INTERVAL '1 MONTH')) || ' :'

                   WHEN Object_GlobalConst.Id = 418996 -- актуальность данных Integer
                        THEN 'Кол-во АП = <' || COALESCE ((SELECT Res FROM tmpProcess_All), '0') || '> из которых :'

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_HistoryCost), '0') <> '0'
                                       THEN ' Р.С/С = <' || COALESCE ((SELECT Res FROM tmpProcess_HistoryCost), '0') || '>'
                                ELSE ''
                                --ELSE ' Расчет С/С = < 1 >'
                             END
                          -- || ' Расчет С/С = <1>'

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Vacuum), '0') <> '0'
                                       THEN ' VAC = <' || COALESCE ((SELECT Res FROM tmpProcess_Vacuum), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Exp), '0') <> '0'
                                       THEN ' Эксп. = <'   || COALESCE ((SELECT Res FROM tmpProcess_Exp), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Inv), '0') <> '0'
                                       THEN ' Инв. = <' || COALESCE ((SELECT Res FROM tmpProcess_Inv), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Rep1), '0') <> '0'
                                       THEN ' О-Пр/В = <' || COALESCE ((SELECT Res FROM tmpProcess_Rep1), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Rep2), '0') <> '0'
                                       THEN ' О-Дв = <'    || COALESCE ((SELECT Res FROM tmpProcess_Rep2), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Rep3), '0') <> '0'
                                       THEN ' О-Ост = <'   || COALESCE ((SELECT Res FROM tmpProcess_Rep3), '0') || '>'
                                  ELSE ''
                             END

                          || ' О-др. = <'   || COALESCE ((SELECT Res FROM tmpProcess_RepOth), '0') || '>'
                          
                      || '  *= <'   || COALESCE ((SELECT EXTRACT(EPOCH FROM AGE (CLOCK_TIMESTAMP(), Query_start)) :: Integer :: TVarChar FROM tmpProcess_Time1), '') || '>'
                          || ' <'   || COALESCE ((SELECT EXTRACT(EPOCH FROM AGE (CLOCK_TIMESTAMP(), Query_start)) :: Integer :: TVarChar FROM tmpProcess_Time2), '') || '>'
                          || ' <'   || COALESCE ((SELECT EXTRACT(EPOCH FROM AGE (CLOCK_TIMESTAMP(), Query_start)) :: Integer :: TVarChar FROM tmpProcess_Time3), '') || '>'
                          || ' <'   || COALESCE ((SELECT Res FROM tmpProcess_Waiting), '0') || '>'
                          

                          -- || '  <'   || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GlobalConst_ConnectParam()), '') || '>'

                   ELSE Object_GlobalConst.ValueData
              END :: TVarChar AS ValueText
            , ObjectString.ValueData AS EnumName
       FROM Object AS Object_GlobalConst
            LEFT JOIN ObjectDate AS ActualBankStatement
                                 ON ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()
                                AND ActualBankStatement.ObjectId = Object_GlobalConst.Id
            LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_GlobalConst.Id
                                  AND ObjectString.DescId = zc_ObjectString_Enum()
       WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
         AND Object_GlobalConst.ObjectCode < 100
         AND Object_GlobalConst.Id NOT IN (zc_Enum_GlobalConst_ConnectParam(), zc_Enum_GlobalConst_ConnectReportParam(), zc_Enum_GlobalConst_ConnectStoredProcParam())
       ORDER BY 1
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GlobalConst (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                                        * add EnumName
 06.04.15                         *
*/

-- тест
-- update Object set valuedata = 'http://integer-srv.alan.dp.ua'  where Id = zc_Enum_GlobalConst_ConnectParam()
-- update Object set valuedata = 'http://integer-srv2.alan.dp.ua' where Id = zc_Enum_GlobalConst_ConnectParam()
--
-- update Object set valuedata = 'http://integer-srv-r.alan.dp.ua'  where Id = zc_Enum_GlobalConst_ConnectReportParam()
-- update Object set valuedata = 'http://integer-srv2-r.alan.dp.ua' where Id = zc_Enum_GlobalConst_ConnectReportParam()
--
-- update Object set valuedata = 'http://integer-srv-a.alan.dp.ua'  where Id = zc_Enum_GlobalConst_ConnectStoredProcParam()
-- update Object set valuedata = 'http://integer-srv2-a.alan.dp.ua' where Id = zc_Enum_GlobalConst_ConnectStoredProcParam()

--
-- SELECT * FROM Object where Id IN (zc_Enum_GlobalConst_ConnectParam(), zc_Enum_GlobalConst_ConnectReportParam())
-- SELECT * FROM gpSelect_Object_GlobalConst ('', zfCalc_UserAdmin())
