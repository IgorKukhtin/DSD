-- Function: spGet_CurrentWeekDay()

DROP FUNCTION IF EXISTS spGet_CurrentWeekDay ( TVarChar);

CREATE OR REPLACE FUNCTION spGet_CurrentWeekDay(
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (isPlan_1  Boolean    , --
               isPlan_2  Boolean    , --
               isPlan_3  Boolean    , --
               isPlan_4  Boolean    , --
               isPlan_5  Boolean    --
              )
AS
$BODY$
   DECLARE vbUserId Integer;
           vbDOW    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession); 
     
     vbDOW := CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0 THEN 7 ELSE EXTRACT (DOW FROM CURRENT_DATE) END :: Integer;

     -- Результат
     RETURN QUERY

     SELECT (vbDOW = 1) :: Boolean AS isPlan_1
          , (vbDOW = 2) ::Boolean  AS isPlan_2
          , (vbDOW = 3) ::Boolean  AS isPlan_3
          , (vbDOW = 4) ::Boolean  AS isPlan_4
          , (vbDOW = 5) ::Boolean  AS isPlan_5
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.                                     
 25.11.25         *
*/

-- тест
-- SELECT * FROM spGet_CurrentWeekDay (inSession:= '2')
