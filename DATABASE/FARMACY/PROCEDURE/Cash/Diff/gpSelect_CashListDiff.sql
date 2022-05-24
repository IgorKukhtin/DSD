-- Function: gpSelect_CashListDiff()

DROP FUNCTION IF EXISTS gpSelect_CashListDiff (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashListDiff(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id              Integer, 
               AmountDiffUser  TFloat,
               AmountDiff      TFloat,
               AmountDiffPrev  TFloat               
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());
     vbUserId:= lpGetUserBySession (inSession);

    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    
    
    -- поиск <Торговой сети>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
   
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey ::Integer;


     RETURN QUERY

       SELECT
               MovementItem.ObjectId                                                                            AS Id, 
               SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime AND 
                   MILO_Insert.ObjectId = vbUserId THEN MovementItem.Amount END)::TFloat                        AS AmountDiffUser,
               SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime THEN MovementItem.Amount END)::TFloat AS AmountDiff,
               SUM(CASE WHEN Movement.OperDate < CURRENT_DATE::TDateTime THEN MovementItem.Amount END)::TFloat  AS AmountDiffPrev 
       FROM Movement 
            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId

            LEFT JOIN MovementItem ON MovementItem.MovementID = Movement.Id 

            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = MovementItem.Id
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
       WHERE Movement.OperDate >= (CURRENT_DATE - interval '1 day')::TDateTime
         AND Movement.DescId = zc_Movement_ListDiff()
       GROUP BY MovementItem.ObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 09.11.18                                                      *
*/

-- тест
-- 
-- SELECT * FROM gpSelect_CashListDiff (inSession:= '3')
-- select * from gpSelect_CashListDiff( inSession := '5323107');
