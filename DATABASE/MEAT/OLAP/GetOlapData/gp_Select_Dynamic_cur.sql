-- Function: gp_select_master_child_cur(tvarchar)

DROP FUNCTION IF EXISTS gp_Select_Dynamic_cur (TVarChar);
-- DROP FUNCTION IF EXISTS  gp_Select_Dynamic_cur (TBlob, TVarChar);
DROP FUNCTION IF EXISTS  gp_Select_Dynamic_cur (TDateTime, TDateTime, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gp_Select_Dynamic_cur (
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inSQL                 TBlob     , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE cur1 refcursor;
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     IF inSQL ILIKE '%FROM SoldTable WHERE%'
        AND vbUserId IN (5, 1058530) -- Няйко В.И.
     THEN inSQL:= SUBSTRING (inSQL FROM 1 FOR POSITION('FROM SoldTable WHERE' IN inSQL) + LENGTH ('FROM SoldTable WHERE') - 1)
             || ' InfoMoneyId = zc_Enum_InfoMoney_30201() AND '
             || SUBSTRING (inSQL FROM POSITION('FROM SoldTable WHERE' IN inSQL) + LENGTH ('FROM SoldTable WHERE') + 0 FOR LENGTH (inSQL))
               ;
     END IF;


     --
     OPEN cur1 FOR EXECUTE inSQL;
     RETURN NEXT cur1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


-- begin; select * from gp_Select_Dynamic_cur('SELECT 10 as DD'::TBlob, '');
-- fetch all "<unnamed portal 4>";
-- fetch all "<unnamed portal 4>";
-- commit;