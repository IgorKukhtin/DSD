-- для SessionGUID - Insert всех данных Movement... в табл. ReplMovement - из которой потом "блоками" идет чтение и формирование скриптов + возвращает сколько всего записей

DROP FUNCTION IF EXISTS gpInsert_ReplMovement (TVarChar, TDateTime, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ReplMovement(
    IN inSessionGUID     TVarChar,      --
    IN inStartDate       TDateTime,     -- Дата/время прошлого формирования данных для реплики
    IN inDescCode        TVarChar,      -- если надо только один вид документа
    IN inDataBaseId      Integer,       -- для формирования GUID

   OUT outCount          Integer,
   OUT outCountString    Integer,
   OUT outCountFloat     Integer,
   OUT outCountDate      Integer,
   OUT outCountBoolean   Integer,
   OUT outCountLink      Integer,
   OUT outCountLinkM     Integer,

   OUT outCountMI        Integer,
   OUT outCountMIString  Integer,
   OUT outCountMIFloat   Integer,
   OUT outCountMIDate    Integer,
   OUT outCountMIBoolean Integer,
   OUT outCountMILink    Integer,

   OUT outMinId          Integer,
   OUT outMaxId          Integer,
   OUT outCountIteration Integer,       -- захардкодили = 3000 - по сколько записей будет возвращать gpSelect_ReplMovement, т.е. inStartId and inEndId
   OUT outCountPack      Integer,       -- захардкодили = 100  - сколько записей в одном Sql для вызова

    IN gConnectHost      TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbDescId Integer;
BEGIN
-- RAISE EXCEPTION 'Ошибка.<%>', inStartDate;
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_...());


     -- !!!удаление "старых" сессий!!!
     DELETE FROM ReplMovement WHERE OperDate < CURRENT_DATE - INTERVAL '2 DAY';

     -- если надо только один Desc
     vbDescId:= COALESCE((SELECT MovementDesc.Id FROM MovementDesc WHERE LOWER (MovementDesc.Code) = LOWER (inDescCode)), 0);


     -- Результат
     INSERT INTO ReplMovement (MovementId, DescId, UserId_last, OperDate_last, OperDate, SessionGUID)
        WITH tmpDesc AS (SELECT MovementDesc.Id AS DescId
                         FROM MovementDesc
                         WHERE (MovementDesc.Id = vbDescId OR vbDescId = 0)
                           AND (MovementDesc.Id IN (zc_Movement_OrderExternal()
                                                  , zc_Movement_EDI()
                                                  , zc_Movement_Promo()
                                                  , zc_Movement_PromoPartner()
                                                  , zc_Movement_WeighingPartner()
                                                  , zc_Movement_Transport()
                                                  , zc_Movement_QualityNumber()
                                                  , zc_Movement_QualityParams()
                                                   )
                             OR vbDescId > 0)
                        )
           , tmpProtocol AS (SELECT Movement.DescId
                                  , MovementProtocol.*
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate DESC) AS Ord
                             FROM MovementProtocol
                                  JOIN Movement ON Movement.Id = MovementProtocol.MovementId
                                               AND (Movement.StatusId <> zc_Enum_Status_Complete()
                                                 OR Movement.DescId <> zc_Movement_WeighingPartner()
                                                   )
                                  JOIN tmpDesc ON tmpDesc.DescId = Movement.DescId
                             WHERE inStartDate               > zc_DateStart()
                               AND MovementProtocol.OperDate >= inStartDate - INTERVAL '1 HOUR' -- на всякий случай, что б отловить ВСЕ изменения
                            )
          , tmpList_0 AS (SELECT tmpProtocol.DescId, tmpProtocol.MovementId
                          FROM tmpProtocol
                          WHERE tmpProtocol.Ord = 1 -- !!!последний!!!
                         )
            , tmpList_1 AS (SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_0
                                 JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = tmpList_0.MovementId
                                 JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                           UNION
                            SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_0
                                 JOIN Movement AS Movement_find ON Movement_find.Id = tmpList_0.MovementId
                                 JOIN Movement ON Movement.Id = Movement_find.ParentId
                           UNION
                            SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_0
                                 JOIN Movement ON Movement.ParentId = tmpList_0.MovementId
                                              AND Movement.DescId   = zc_Movement_PromoPartner()
                           )
            , tmpList_2 AS (SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_1
                                 JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = tmpList_1.MovementId
                                 JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                           UNION
                            SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_1
                                 JOIN Movement AS Movement_find ON Movement_find.Id = tmpList_1.MovementId
                                 JOIN Movement ON Movement.Id = Movement_find.ParentId
                           UNION
                            SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_1
                                 JOIN Movement ON Movement.ParentId = tmpList_1.MovementId
                                              AND Movement.DescId   = zc_Movement_PromoPartner()
                           )
            , tmpList_3 AS (SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_2
                                 JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = tmpList_2.MovementId
                                 JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                           UNION
                            SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_2
                                 JOIN Movement AS Movement_find ON Movement_find.Id = tmpList_2.MovementId
                                 JOIN Movement ON Movement.Id = Movement_find.ParentId
                           UNION
                            SELECT DISTINCT Movement.DescId, Movement.Id AS MovementId
                            FROM tmpList_2
                                 JOIN Movement ON Movement.ParentId = tmpList_2.MovementId
                                              AND Movement.DescId   = zc_Movement_PromoPartner()
                           )
        , tmpList_all AS (SELECT tmpList_0.DescId, tmpList_0.MovementId FROM tmpList_0
                         UNION
                          SELECT tmpList_1.DescId, tmpList_1.MovementId FROM tmpList_1
                         UNION
                          SELECT tmpList_2.DescId, tmpList_2.MovementId FROM tmpList_2
                         UNION
                          SELECT tmpList_3.DescId, tmpList_3.MovementId FROM tmpList_3
                         )
     -- Результат
     SELECT tmpList_all.MovementId, tmpList_all.DescId, tmpProtocol.UserId AS UserId_last, tmpProtocol.OperDate AS OperDate_last, CURRENT_TIMESTAMP AS OperDate, inSessionGUID
     FROM tmpList_all
          LEFT JOIN tmpProtocol ON tmpProtocol.MovementId = tmpList_all.MovementId AND tmpProtocol.Ord = 1 -- !!!последний!!!
     ORDER BY tmpList_all.MovementId;


     -- Проверка
     /*IF NOT EXISTS (SELECT ReplMovement.MovementId FROM ReplMovement WHERE ReplMovement.SessionGUID = inSessionGUID AND ReplMovement.MovementId = 9725956)
        AND EXISTS (SELECT ReplMovement.MovementId FROM ReplMovement WHERE ReplMovement.SessionGUID = inSessionGUID AND ReplMovement.MovementId = 9725941)
     THEN
         RAISE EXCEPTION 'NOT EXISTS';
     END IF;*/

     -- Проверка
     IF EXISTS (SELECT ReplMovement.MovementId FROM ReplMovement WHERE ReplMovement.SessionGUID = inSessionGUID GROUP BY ReplMovement.MovementId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'ReplMovement - COUNT() > 1 : <%> <%>', (SELECT ReplMovement.MovementId FROM ReplMovement WHERE ReplMovement.SessionGUID = inSessionGUID GROUP BY ReplMovement.MovementId HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1)
                                                               , (SELECT Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate) FROM ReplMovement JOIN Movement ON Movement.Id = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID GROUP BY ReplMovement.MovementId HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1)
                                                                ;
     END IF;


     -- кроме теста
     IF inDataBaseId > 0
     THEN
         -- для Результата - сформировали GUID
         INSERT INTO MovementString (MovementId, DescId, ValueData)
           SELECT ReplMovement.MovementId, zc_MovementString_GUID()

                  -- !!!КЛЮЧ!!!
                , ReplMovement.MovementId :: TVarChar || ' - M - ' || inDataBaseId :: TVarChar AS ValueData

           FROM ReplMovement
                LEFT JOIN MovementString ON MovementString.MovementId = ReplMovement.MovementId AND MovementString.DescId = zc_MovementString_GUID()
           WHERE ReplMovement.SessionGUID = inSessionGUID
             AND MovementString.MovementId IS NULL
          ;

         -- для Результата - сформировали GUID
         INSERT INTO MovementItemString (MovementItemId, DescId, ValueData)
           SELECT MovementItem.Id, zc_MIString_GUID()

                  -- !!!КЛЮЧ!!!
                , MovementItem.Id :: TVarChar || ' - MI - ' || inDataBaseId :: TVarChar AS ValueData

           FROM ReplMovement
                INNER JOIN MovementItem ON MovementItem.MovementId = ReplMovement.MovementId
                LEFT JOIN MovementItemString ON MovementItemString.MovementItemId = MovementItem.Id AND MovementItemString.DescId = zc_MIString_GUID()
           WHERE ReplMovement.SessionGUID = inSessionGUID
             AND MovementItemString.MovementItemId IS NULL
          ;
     END IF;


     -- Результат
     SELECT
          COUNT (*)             AS outCount
        , MIN (ReplMovement.Id) AS outMinId
        , MAX (ReplMovement.Id) AS outMaxId
          -- !!!временно ЗАХАРДКОДИЛИ!!! - по сколько записей будет возвращать gpSelect_ReplMovement, т.е. inStartId and inEndId
        , 5000                  AS CountIteration
          -- !!!временно ЗАХАРДКОДИЛИ!!! - сколько записей в одном Sql для вызова
        , 200                   AS CountPack
          --
          INTO outCount, outMinId, outMaxId, outCountIteration, outCountPack
     FROM ReplMovement
     WHERE ReplMovement.SessionGUID = inSessionGUID
    ;

     -- Результат
     outCount          := COALESCE (outCount, 0);
     outCountString    := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementString       AS MS  ON MS.MovementId  = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountFloat     := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementFloat        AS MF  ON MF.MovementId  = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountDate      := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementDate         AS MD  ON MD.MovementId  = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountBoolean   := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementBoolean      AS MB  ON MB.MovementId  = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountLink      := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementLinkObject   AS MLO ON MLO.MovementId = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountLinkM     := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementLinkMovement AS MLM ON MLM.MovementId = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID), 0);

     outCountMI       := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementItem AS MI ON MI.MovementId = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountMIString := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementItem AS MI ON MI.MovementId = ReplMovement.MovementId INNER JOIN MovementItemString     AS MIS ON MIS.MovementItemId = MI.Id WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountMIFloat  := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementItem AS MI ON MI.MovementId = ReplMovement.MovementId INNER JOIN MovementItemFloat      AS MIF ON MIF.MovementItemId = MI.Id WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountMIDate   := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementItem AS MI ON MI.MovementId = ReplMovement.MovementId INNER JOIN MovementItemDate       AS MID ON MID.MovementItemId = MI.Id WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountMIBoolean:= COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementItem AS MI ON MI.MovementId = ReplMovement.MovementId INNER JOIN MovementItemBoolean    AS MIB ON MIB.MovementItemId = MI.Id WHERE ReplMovement.SessionGUID = inSessionGUID), 0);
     outCountMILink   := COALESCE ((SELECT COUNT(*) FROM ReplMovement INNER JOIN MovementItem AS MI ON MI.MovementId = ReplMovement.MovementId INNER JOIN MovementItemLinkObject AS MIO ON MIO.MovementItemId = MI.Id WHERE ReplMovement.SessionGUID = inSessionGUID), 0);

     outMinId          := COALESCE (outMinId, 0);
     outMaxId          := COALESCE (outMaxId, 0);
     outCountIteration := COALESCE (outCountIteration, 0);
     outCountPack      := COALESCE (outCountPack, 0);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.18                                        *
*/

-- тест
-- SELECT * FROM ReplMovement ORDER BY Id DESC;
-- TRUNCATE TABLE ReplMovement;
-- SELECT * FROM gpInsert_ReplMovement  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDescCode:= '', inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpInsert_ReplMovement  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDescCode:= '', inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin())
