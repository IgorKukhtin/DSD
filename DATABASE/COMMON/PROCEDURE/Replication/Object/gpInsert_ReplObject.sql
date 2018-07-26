-- для SessionGUID - Insert всех данных Object в табл. ReplObject - из которой потом "блоками" идет чтение и формирование скриптов + возвращает сколько всего записей

DROP FUNCTION IF EXISTS gpInsert_ReplObject (TVarChar, TDateTime, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ReplObject (TVarChar, TDateTime, TVarChar, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ReplObject (TVarChar, TDateTime, TVarChar, Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ReplObject(
    IN inSessionGUID     TVarChar,      --
    IN inStartDate       TDateTime,     --
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
   OUT outCountPack      Integer,       -- захардкодили =  100 - сколько записей в одном Sql для вызова

    IN gConnectHost      TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- !!!удаление "старых" сессий!!!
     DELETE FROM ReplObject WHERE OperDate < CURRENT_DATE - INTERVAL '2 DAY';

     -- если надо только один Desc
     vbDescId:= COALESCE((SELECT ObjectDesc.Id FROM ObjectDesc WHERE LOWER (ObjectDesc.Code) = LOWER (inDescCode)), 0);


     -- Результат
     INSERT INTO ReplObject (ObjectId, DescId, UserId_last, OperDate_last, OperDate, SessionGUID)
        WITH tmpDesc AS (SELECT ObjectDesc.Id AS DescId
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
                               AND ObjectProtocol.OperDate >= inStartDate - INTERVAL '1 HOUR' -- на всякий случай, что отловить ВСЕ изменения
                            )
          , tmpList_0 AS (SELECT tmpProtocol.DescId, tmpProtocol.ObjectId
                          FROM tmpProtocol
                          WHERE tmpProtocol.Ord = 1 -- !!!последний!!!
                         UNION
                          SELECT Object.DescId, Object.Id AS ObjectId
                          FROM tmpDesc
                               INNER JOIN Object ON Object.DescId = tmpDesc.DescId
                          WHERE inIsProtocol = FALSE
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
     SELECT tmpList_all.ObjectId, tmpList_all.DescId, tmpProtocol.UserId AS UserId_last, tmpProtocol.OperDate AS OperDate_last, CURRENT_TIMESTAMP, inSessionGUID
     FROM tmpList_all
          LEFT JOIN tmpProtocol ON tmpProtocol.ObjectId = tmpList_all.ObjectId AND tmpProtocol.Ord = 1 -- !!!последний!!!
     ORDER BY tmpList_all.ObjectId;


     -- Проверка
     IF EXISTS (SELECT ReplObject.ObjectId FROM ReplObject WHERE ReplObject.SessionGUID = inSessionGUID GROUP BY ReplObject.ObjectId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'ReplObject - COUNT() > 1 : <%>', (SELECT ReplObject.ObjectId FROM ReplObject WHERE ReplObject.SessionGUID = inSessionGUID GROUP BY ReplObject.ObjectId HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1)
                                 , lfGet_Object_ValueData ((SELECT ReplObject.ObjectId FROM ReplObject WHERE ReplObject.SessionGUID = inSessionGUID GROUP BY ReplObject.ObjectId HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1))
                                   ;
     END IF;


     -- для Результата - сформировали GUID
     INSERT INTO ObjectString (ObjectId, DescId, ValueData)
       SELECT ReplObject.ObjectId, zc_ObjectString_GUID(), ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar AS ValueData
       FROM ReplObject
            LEFT JOIN ObjectString ON ObjectString.ObjectId = ReplObject.ObjectId AND ObjectString.DescId = zc_ObjectString_GUID()
       WHERE ReplObject.SessionGUID = inSessionGUID
         AND ObjectString.ObjectId IS NULL
      ;


     -- Результат
     SELECT
          COUNT (*)           AS outCount
        , MIN (ReplObject.Id) AS outMinId
        , MAX (ReplObject.Id) AS outMaxId
          -- !!!временно ЗАХАРДКОДИЛИ!!! - по сколько записей будет возвращать gpSelect_ReplObject, т.е. inStartId and inEndId
        , 3000                AS CountIteration
          -- !!!временно ЗАХАРДКОДИЛИ!!! - сколько записей в одном Sql для вызова
        , 100                 AS CountPack
          --
          INTO outCount, outMinId, outMaxId, outCountIteration, outCountPack
     FROM ReplObject
     WHERE ReplObject.SessionGUID = inSessionGUID
    ;

     -- Результат
     outCount          := COALESCE (outCount, 0);
     outCountString    := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectString  ON ObjectString.ObjectId  = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountFloat     := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectFloat   ON ObjectFloat.ObjectId   = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountDate      := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectDate    ON ObjectDate.ObjectId    = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountBoolean   := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountLink      := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectLink    ON ObjectLink.ObjectId    = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);

     outCountHistory       := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory ON ObjectHistory.ObjectId = ReplObject.ObjectId WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountHistoryString := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory ON ObjectHistory.ObjectId = ReplObject.ObjectId INNER JOIN ObjectHistoryString ON ObjectHistoryString.ObjectHistoryId = ObjectHistory.Id WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountHistoryFloat  := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory ON ObjectHistory.ObjectId = ReplObject.ObjectId INNER JOIN ObjectHistoryFloat  ON ObjectHistoryFloat.ObjectHistoryId  = ObjectHistory.Id WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountHistoryDate   := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory ON ObjectHistory.ObjectId = ReplObject.ObjectId INNER JOIN ObjectHistoryDate   ON ObjectHistoryDate.ObjectHistoryId   = ObjectHistory.Id WHERE ReplObject.SessionGUID = inSessionGUID), 0);
     outCountHistoryLink   := COALESCE ((SELECT COUNT(*) FROM ReplObject INNER JOIN ObjectHistory ON ObjectHistory.ObjectId = ReplObject.ObjectId INNER JOIN ObjectHistoryLink   ON ObjectHistoryLink.ObjectHistoryId   = ObjectHistory.Id WHERE ReplObject.SessionGUID = inSessionGUID), 0);

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
-- SELECT * FROM gpInsert_ReplObject  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDescCode:= '', inIsProtocol:= FALSE, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpInsert_ReplObject  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartDate:= CURRENT_TIMESTAMP - INTERVAL '1 DAY', inDescCode:= '', inIsProtocol:= TRUE,  inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin())
