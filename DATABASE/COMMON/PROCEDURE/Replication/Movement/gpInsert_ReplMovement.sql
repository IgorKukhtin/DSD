-- для SessionGUID - Insert всех данных Movement... в табл. ReplMovement - из которой потом "блоками" идет чтение и формирование скриптов + возвращает сколько всего записей

DROP FUNCTION IF EXISTS gpInsert_ReplMovement (TVarChar, TDateTime, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ReplMovement(
    IN inSessionGUID     TVarChar,      --
    IN inStartDate       TDateTime,     --
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
                                                   )
                             OR vbDescId > 0)
                        )
           , tmpProtocol AS (SELECT Movement.DescId
                                  , MovementProtocol.*
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate DESC) AS Ord
                             FROM MovementProtocol
                                  JOIN Movement ON Movement.Id = MovementProtocol.MovementId
                                  JOIN tmpDesc ON tmpDesc.DescId = Movement.DescId
                             WHERE inStartDate               > zc_DateStart()
                               AND MovementProtocol.OperDate >= inStartDate - INTERVAL '1 HOUR' -- на всякий случай, что отловить ВСЕ изменения
                            )
        , tmpList_all AS (SELECT tmpProtocol.DescId, tmpProtocol.MovementId
                          FROM tmpProtocol
                          WHERE tmpProtocol.Ord = 1 -- !!!последний!!!
                         )
     -- Результат
     SELECT tmpList_all.MovementId, tmpList_all.DescId, tmpProtocol.UserId AS UserId_last, tmpProtocol.OperDate AS OperDate_last, CURRENT_TIMESTAMP AS OperDate, inSessionGUID
     FROM tmpList_all
          LEFT JOIN tmpProtocol ON tmpProtocol.MovementId = tmpList_all.MovementId AND tmpProtocol.Ord = 1 -- !!!последний!!!
     ORDER BY tmpList_all.MovementId;


     -- Проверка
     IF EXISTS (SELECT ReplMovement.MovementId FROM ReplMovement WHERE ReplMovement.SessionGUID = inSessionGUID GROUP BY ReplMovement.MovementId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'ReplMovement - COUNT() > 1 : <%>', (SELECT ReplMovement.MovementId FROM ReplMovement WHERE ReplMovement.SessionGUID = inSessionGUID GROUP BY ReplMovement.MovementId HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1)
                                                           , (SELECT Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate) FROM ReplMovement JOIN Movement ON Movement.Id = ReplMovement.MovementId WHERE ReplMovement.SessionGUID = inSessionGUID GROUP BY ReplMovement.MovementId HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1)
                                                            ;
     END IF;


     -- кроме теста
     IF inDataBaseId > 0
     THEN
         -- для Результата - сформировали GUID
         INSERT INTO MovementString (MovementId, DescId, ValueData)
           SELECT ReplMovement.MovementId, zc_MovementString_GUID(), ReplMovement.MovementId :: TVarChar || ' - ' || inDataBaseId :: TVarChar AS ValueData
           FROM ReplMovement
                LEFT JOIN MovementString ON MovementString.MovementId = ReplMovement.MovementId AND MovementString.DescId = zc_MovementString_GUID()
           WHERE ReplMovement.SessionGUID = inSessionGUID
             AND MovementString.MovementId IS NULL
          ;
     END IF;


     -- Результат
     SELECT
          COUNT (*)             AS outCount
        , MIN (ReplMovement.Id) AS outMinId
        , MAX (ReplMovement.Id) AS outMaxId
          -- !!!временно ЗАХАРДКОДИЛИ!!! - по сколько записей будет возвращать gpSelect_ReplMovement, т.е. inStartId and inEndId
        , 3000                  AS CountIteration
          -- !!!временно ЗАХАРДКОДИЛИ!!! - сколько записей в одном Sql для вызова
        , 100                   AS CountPack
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
