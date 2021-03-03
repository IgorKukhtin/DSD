-- Function: lfSelect_Object_Account_Level ()

DROP FUNCTION IF EXISTS lfSelect_Object_Account_Level (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Account_Level(
    IN inUserId    Integer      --
)
RETURNS TABLE (AccountId Integer)
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY 
       WITH tmpLevelMax01    AS (SELECT 1 FROM Constant_User_LevelMax01_View  WHERE Constant_User_LevelMax01_View.UserId  = inUserId LIMIT 1)
          , tmpLevelHigh02   AS (SELECT 1 FROM Constant_User_LevelHigh02_View WHERE Constant_User_LevelHigh02_View.UserId = inUserId AND NOT EXISTS (SELECT * FROM tmpLevelMax01) LIMIT 1)
          , tmpLevelMedium03 AS (SELECT 1 FROM Constant_User_Medium03_View    WHERE Constant_User_Medium03_View.UserId    = inUserId AND NOT EXISTS (SELECT * FROM tmpLevelMax01 UNION SELECT * FROM tmpLevelHigh02) LIMIT 1)
          , tmpLevelNormal04 AS (SELECT 1 FROM Constant_User_Normal04_View    WHERE Constant_User_Normal04_View.UserId    = inUserId AND NOT EXISTS (SELECT * FROM tmpLevelMax01 UNION SELECT * FROM tmpLevelHigh02 UNION SELECT * FROM tmpLevelMedium03) LIMIT 1)
          , tmpLevelLover05  AS (SELECT 1 WHERE 1 = 0 AND NOT EXISTS (SELECT * FROM tmpLevelMax01 UNION SELECT * FROM tmpLevelHigh02 UNION SELECT * FROM tmpLevelMedium03 UNION SELECT * FROM tmpLevelNormal04) LIMIT 1)
          , tmpLevelMin06    AS (SELECT 1 WHERE 1 = 0 AND NOT EXISTS (SELECT * FROM tmpLevelMax01 UNION SELECT * FROM tmpLevelHigh02 UNION SELECT * FROM tmpLevelMedium03 UNION SELECT * FROM tmpLevelNormal04 UNION SELECT * FROM tmpLevelLover05) LIMIT 1)
          , tmpLevel07       AS (SELECT 1           WHERE NOT EXISTS (SELECT * FROM tmpLevelMax01 UNION SELECT * FROM tmpLevelHigh02 UNION SELECT * FROM tmpLevelMedium03 UNION SELECT * FROM tmpLevelNormal04 UNION SELECT * FROM tmpLevelLover05 UNION SELECT * FROM tmpLevelMin06) LIMIT 1)

       -- Результат
       SELECT Object_Account.Id AS AccountId
       FROM tmpLevelMax01
            LEFT JOIN Object AS Object_Account ON Object_Account.DescId = zc_Object_Account()

      UNION
       SELECT Object_Account.Id AS AccountId
       FROM tmpLevelHigh02
            LEFT JOIN Object AS Object_Account ON Object_Account.DescId = zc_Object_Account()

      UNION
       SELECT Object_Account.Id AS AccountId
       FROM tmpLevelMedium03
            LEFT JOIN Object AS Object_Account ON Object_Account.DescId = zc_Object_Account()

      UNION
       SELECT Object_Account_View.AccountId
       FROM tmpLevelNormal04
            LEFT JOIN Object_Account_View ON Object_Account_View.AccountDirectionId <> zc_Enum_AccountDirection_70500() -- Сотрудники + Заработная плата

      UNION
       SELECT Object_Account_View.AccountId
       FROM tmpLevel07
            LEFT JOIN Object_Account_View ON Object_Account_View.AccountGroupId <> zc_Enum_AccountGroup_100000() -- Собственный капитал
                                         AND Object_Account_View.AccountDirectionId <> zc_Enum_AccountDirection_70500() -- Сотрудники + Заработная плата
      ;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
  ALTER FUNCTION lfSelect_Object_Account_Level (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.15                                        *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Account_Level (zfCalc_UserAdmin() :: Integer) AS tmp LEFT JOIN Object ON Object.Id = tmp.AccountId ORDER BY ObjectCode
