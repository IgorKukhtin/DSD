-- для SessionGUID - Insert всех данных Object в табл. ReplObject - из которой потом "блоками" идет чтение и формирование скриптов + возвращает сколько всего записей

DROP FUNCTION IF EXISTS gpInsert_ReplObject (TVarChar, TDateTime, TVarChar, Boolean, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ReplObject (TVarChar, TVarChar, TDateTime, TVarChar, Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ReplObject(
    IN inSessionGUID     TVarChar,      --
    IN inSessionGUID_mov TVarChar,      --
    IN inStartDate       TDateTime,     -- Дата/время прошлого формирования данных для реплики
    IN inDescCode        TVarChar,      -- если надо только один справочник
    IN inIsProtocol      Boolean,       -- данные зависят от inStartDate или все записи
    IN inDataBaseId      Integer,       -- для формирования GUID

   OUT outCount          Integer,
   OUT outCountString    Integer,
   OUT outCountFloat     Integer,
   OUT outCountDate      Integer,
   OUT outCountBoolean   Integer,
   OUT outCountLink      Integer,

   OUT outCountHistory       Integer,
   OUT outCountHistoryString Integer,
   OUT outCountHistoryFloat  Integer,
   OUT outCountHistoryDate   Integer,
   OUT outCountHistoryLink   Integer,

   OUT outMinId          Integer,
   OUT outMaxId          Integer,
   OUT outCountIteration Integer,       -- захардкодили = 3000 - по сколько записей будет возвращать gpSelect_ReplObject, т.е. inStartId and inEndId
   OUT outCountPack      Integer,       -- захардкодили = 100  - сколько записей в одном Sql для вызова

    IN gConnectHost      TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbDescId Integer;
BEGIN
-- RAISE EXCEPTION 'Ошибка.<%>', inSessionGUID_mov;
     -- проверка прав пользователя на вызов процедуры-*
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_...());


     -- !!!удаление "старых" сессий!!!
     DELETE FROM ReplObject WHERE OperDate < CURRENT_DATE - INTERVAL '2 DAY';

     -- если надо только один Desc
     vbDescId:= COALESCE((SELECT ObjectDesc.Id FROM ObjectDesc WHERE LOWER (ObjectDesc.Code) = LOWER (inDescCode)), 0);


     -- Результат
     INSERT INTO ReplObject (ObjectId, DescId, UserId_last, OperDate_last, OperDate, SessionGUID)
        WITH tmpList_ReplMovement AS (WITH tmpReplMovement AS (SELECT ReplMovement.*
                                                               FROM ReplMovement
                                                               WHERE ReplMovement.SessionGUID = inSessionGUID_mov
                                                              )
                                      -- из MovementLinkObject
                                      SELECT DISTINCT Object.DescId, Object.Id AS ObjectId
                                      FROM tmpReplMovement AS ReplMovement
                                           INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = ReplMovement.MovementId
                                           INNER JOIN Object ON Object.Id = MovementLinkObject.ObjectId
                                     UNION
                                      -- из MovementItem
                                      SELECT DISTINCT Object.DescId, Object.Id AS ObjectId
                                      FROM tmpReplMovement AS ReplMovement
                                           INNER JOIN MovementItem ON MovementItem.MovementId = ReplMovement.MovementId
                                           INNER JOIN Object ON Object.Id = MovementItem.ObjectId
                                     UNION
                                      -- из MovementItemLinkObject
                                      SELECT DISTINCT Object.DescId, Object.Id AS ObjectId
                                      FROM tmpReplMovement AS ReplMovement
                                           INNER JOIN MovementItem ON MovementItem.MovementId = ReplMovement.MovementId
                                           INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                           INNER JOIN Object ON Object.Id = MovementItemLinkObject.ObjectId
                                     )
            , tmpDesc AS (-- все Desc
                         SELECT DISTINCT tmpList_ReplMovement.DescId FROM tmpList_ReplMovement
                        UNION
                         SELECT ObjectDesc.Id AS DescId
                         FROM ObjectDesc
                         WHERE (ObjectDesc.Id = vbDescId OR vbDescId = 0)
                           AND (ObjectDesc.Id IN (zc_Object_Role()
                                                , zc_Object_User()
                                                , zc_Object_PaidKind()
                                                , zc_Object_Member()
                                                , zc_Object_Personal()
                                                , zc_Object_Goods()
                                                , zc_Object_GoodsByGoodsKind()
                                                , zc_Object_GoodsProperty()
                                                , zc_Object_GoodsPropertyValue()
                                                , zc_Object_GoodsKind()
                                                , zc_Object_PriceListItem()
                                                , zc_Object_Box()
                                                , zc_Object_Unit()
                                                , zc_Object_Route()
                                                , zc_Object_Retail()
                                                , zc_Object_Juridical()
                                                , zc_Object_Contract()
                                                , zc_Object_Partner()
                                                , zc_Object_Bank()
                                                , zc_Object_BankAccount()
                                                , zc_Object_Currency()
                                                , zc_Object_BankAccountContract()
                                                -- , zc_Object_CorrespondentAccountIntermediaryBank()
                                                  --
                                                , zc_Object_ToolsWeighing()
                                                , zc_Object_GoodsKindWeighing()
                                                , zc_Object_GoodsKindWeighingGroup()
                                                , zc_Object_ReestrKind()
                                                , zc_Object_ArticleLoss()
                                                 )
                             OR vbDescId > 0)
                        )
           , tmpProtocol AS (SELECT Object.DescId
                                  , ObjectProtocol.*
                                    -- № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                             FROM ObjectProtocol
                                  JOIN Object ON Object.Id = ObjectProtocol.ObjectId
                                  JOIN tmpDesc ON tmpDesc.DescId = Object.DescId
                             WHERE inStartDate             > zc_DateStart()
                               AND inIsProtocol            = TRUE
                               AND ObjectProtocol.OperDate >= inStartDate - INTERVAL '1 HOUR' -- на всякий случай, что б отловить ВСЕ изменения
                            )
          , tmpList_0 AS (-- если надо - из протокола,
                          SELECT tmpProtocol.DescId, tmpProtocol.ObjectId
                          FROM tmpProtocol
                          WHERE tmpProtocol.Ord = 1 -- !!!последний!!!
                         UNION
                          -- здесь ВСЕ
                          SELECT Object.DescId, Object.Id AS ObjectId
                          FROM tmpDesc
                               INNER JOIN Object ON Object.DescId = tmpDesc.DescId
                          WHERE inIsProtocol = FALSE
                         UNION
                          -- из ReplMovement
                          SELECT tmpList_ReplMovement.DescId, tmpList_ReplMovement.ObjectId FROM tmpList_ReplMovement
                         )
          , tmpList_1 AS (SELECT DISTINCT Object.DescId, ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_0
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_0.ObjectId
                               JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                         UNION
                          SELECT DISTINCT Object.DescId, ObjectHistoryLink.ObjectId AS ObjectId
                          FROM tmpList_0
                               JOIN ObjectHistory     ON ObjectHistory.ObjectId            = tmpList_0.ObjectId
                               JOIN ObjectHistoryLink ON ObjectHistoryLink.ObjectHistoryId = ObjectHistory.Id
                               JOIN Object ON Object.Id = ObjectHistoryLink.ObjectId
                         )
          , tmpList_2 AS (SELECT DISTINCT Object.DescId, ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_1
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_1.ObjectId
                               JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                         UNION
                          SELECT DISTINCT Object.DescId, ObjectHistoryLink.ObjectId AS ObjectId
                          FROM tmpList_1
                               JOIN ObjectHistory     ON ObjectHistory.ObjectId            = tmpList_1.ObjectId
                               JOIN ObjectHistoryLink ON ObjectHistoryLink.ObjectHistoryId = ObjectHistory.Id
                               JOIN Object ON Object.Id = ObjectHistoryLink.ObjectId
                         )
          , tmpList_3 AS (SELECT DISTINCT Object.DescId, ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_2
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_2.ObjectId
                               JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                         UNION
                          SELECT DISTINCT Object.DescId, ObjectHistoryLink.ObjectId AS ObjectId
                          FROM tmpList_2
                               JOIN ObjectHistory     ON ObjectHistory.ObjectId            = tmpList_2.ObjectId
                               JOIN ObjectHistoryLink ON ObjectHistoryLink.ObjectHistoryId = ObjectHistory.Id
                               JOIN Object ON Object.Id = ObjectHistoryLink.ObjectId
                         )
          , tmpList_4 AS (SELECT DISTINCT Object.DescId, ObjectLink.ChildObjectId AS ObjectId
                          FROM tmpList_3
                               JOIN ObjectLink ON ObjectLink.ObjectId = tmpList_3.ObjectId
                               JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                         UNION
                          SELECT DISTINCT Object.DescId, ObjectHistoryLink.ObjectId AS ObjectId
                          FROM tmpList_3
                               JOIN ObjectHistory     ON ObjectHistory.ObjectId            = tmpList_3.ObjectId
                               JOIN ObjectHistoryLink ON ObjectHistoryLink.ObjectHistoryId = ObjectHistory.Id
                               JOIN Object ON Object.Id = ObjectHistoryLink.ObjectId
                         )
        , tmpList_all AS (SELECT tmpList_0.DescId, tmpList_0.ObjectId FROM tmpList_0
                         UNION
                          SELECT tmpList_1.DescId, tmpList_1.ObjectId FROM tmpList_1
                         UNION
                          SELECT tmpList_2.DescId, tmpList_2.ObjectId FROM tmpList_2
                         UNION
                          SELECT tmpList_3.DescId, tmpList_3.ObjectId FROM tmpList_3
                         UNION
                          SELECT tmpList_4.DescId, tmpList_4.ObjectId FROM tmpList_4
                         )
     -- Результат
     SELECT tmpList_all.ObjectId, tmpList_all.DescId, tmpProtocol.UserId AS UserId_last, tmpProtocol.OperDate AS OperDate_last, CURRENT_TIMESTAMP AS OperDate, inSessionGUID
     FROM tmpList_all
          LEFT JOIN tmpProtocol ON tmpProtocol.ObjectId = tmpList_all.ObjectId AND tmpProtocol.Ord = 1 -- !!!последний!!!
     ORDER BY tmpList_all.ObjectId;


     -- Проверка
     IF EXISTS (SELECT ReplObject.ObjectId FROM ReplObject WHERE ReplObject.SessionGUID = inSessionGUID GROUP BY ReplObject.ObjectId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'ReplObject - COUNT() > 1 : <%> <%>', (SELECT ReplObject.ObjectId FROM ReplObject WHERE ReplObject.SessionGUID = inSessionGUID GROUP BY ReplObject.ObjectId HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1)
                                     , lfGet_Object_ValueData ((SELECT ReplObject.ObjectId FROM ReplObject WHERE ReplObject.SessionGUID = inSessionGUID GROUP BY ReplObject.ObjectId HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1))
                                      ;
     END IF;


     -- кроме теста
     IF inDataBaseId > 0
     THEN
         -- для Результата - сформировали GUID
         INSERT INTO ObjectString (ObjectId, DescId, ValueData)
           SELECT ReplObject.ObjectId, zc_ObjectString_GUID()

                  -- !!!КЛЮЧ!!!
                , ReplObject.ObjectId :: TVarChar || ' - O - ' || inDataBaseId :: TVarChar AS ValueData

           FROM ReplObject
                LEFT JOIN ObjectString ON ObjectString.ObjectId = ReplObject.ObjectId AND ObjectString.DescId = zc_ObjectString_GUID()
           WHERE ReplObject.SessionGUID = inSessionGUID
             AND ObjectString.ObjectId IS NULL
          ;
     END IF;


     -- Результат
     SELECT
          COUNT (*)           AS outCount
        , MIN (ReplObject.Id) AS outMinId
        , MAX (ReplObject.Id) AS outMaxId
          -- !!!временно ЗАХАРДКОДИЛИ!!! - по сколько записей будет возвращать gpSelect_ReplObject, т.е. inStartId and inEndId
        , 20000               AS CountIteration
          -- !!!временно ЗАХАРДКОДИЛИ!!! - сколько записей в одном Sql для вызова
        , 400                 AS CountPack
          --
          INTO outCount, outMinId, outMaxId, outCountIteration, outCountPack
     FROM ReplObject
     WHERE ReplObject.SessionGUID = inSessionGUID
    ;

     -- Результат
     outCount          := COALESCE (outCount, 0);
     outCountString    := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectString  AS OS  ON OS.ObjectId  = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountFloat     := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectFloat   AS OFl ON OFl.ObjectId = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountDate      := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectDate    AS OD  ON OD.ObjectId  = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountBoolean   := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectBoolean AS OB  ON OB.ObjectId  = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountLink      := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectLink    AS OL  ON OL.ObjectId  = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);

     outCountHistory       := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory AS OH ON OH.ObjectId = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountHistoryString := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory AS OH ON OH.ObjectId = ReplObject.ObjectId INNER JOIN ObjectHistoryString AS OHS ON OHS.ObjectHistoryId = OH.Id WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountHistoryFloat  := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory AS OH ON OH.ObjectId = ReplObject.ObjectId INNER JOIN ObjectHistoryFloat  AS OHF ON OHF.ObjectHistoryId = OH.Id WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountHistoryDate   := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory AS OH ON OH.ObjectId = ReplObject.ObjectId INNER JOIN ObjectHistoryDate   AS OHD ON OHD.ObjectHistoryId = OH.Id WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountHistoryLink   := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory AS OH ON OH.ObjectId = ReplObject.ObjectId INNER JOIN ObjectHistoryLink   AS OHL ON OHL.ObjectHistoryId = OH.Id WHERE ReplObject.SessionGUID = inSessionGUID), 0);

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
 30.06.18                                        *
*/

-- тест
-- SELECT * FROM ReplObject ORDER BY Id DESC;
-- TRUNCATE TABLE ReplObject;
-- SELECT * FROM gpInsert_ReplObject  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inSessionGUID_mov:= '', inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDescCode:= '', inIsProtocol:= FALSE, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpInsert_ReplObject  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inSessionGUID_mov:= '', inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDescCode:= '', inIsProtocol:= TRUE,  inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin())
