-- Function: gpReport_GoodsSaleChechUser()

DROP FUNCTION IF EXISTS gpReport_GoodsSaleChechUser (TDateTime, TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsSaleChechUser(
    IN inStartDate   TDateTime,     -- Дата начисления
    IN inEndDate     TDateTime,     -- Дата начисления
    IN inUnitID      Integer,       -- Аптека
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UserName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbUnitKey TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

   -- Для роли "Кассир" проверяем 
   IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
             WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
   THEN
      vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
      IF vbUnitKey = '' THEN
         vbUnitKey := '0';
      END IF;

      inUnitID := vbUnitKey::Integer;
   END IF;
   

     -- Результат
   RETURN QUERY
    WITH tmpCheckAll AS (
            SELECT Movement.ID                                                             AS ID
                 , Movement.OperDate                                                       AS OperDate
                 , MovementLinkObject_Unit.ObjectId                                        AS UnitId
                 , MLO_Insert.ObjectId                                                     AS UserID
            FROM Movement

                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                              AND MovementLinkObject_Unit.ObjectId = inUnitID

                 INNER JOIN MovementLinkObject AS MLO_Insert
                                               ON MLO_Insert.MovementId = Movement.Id
                                              AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()

                 LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                           ON MovementBoolean_CorrectMarketing.MovementId = Movement.Id
                                          AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()

                 LEFT JOIN MovementBoolean AS MovementBoolean_Doctors
                                           ON MovementBoolean_Doctors.MovementId = Movement.Id
                                          AND MovementBoolean_Doctors.DescId = zc_MovementBoolean_Doctors()

                                               
            WHERE Movement.OperDate >= date_trunc('day', inStartDate)
              AND Movement.OperDate < date_trunc('day', inEndDate) + INTERVAL '1 DAY'
              AND Movement.DescId = zc_Movement_Check()
              AND Movement.StatusId = zc_Enum_Status_Complete())

     SELECT Object_User.ValueData                          AS UserName
          , Object_Goods.ObjectCode                        AS GoodsCode
          , Object_Goods.ValueData                         AS GoodsName
          
          , Sum(- MovementItemContainer.Amount)::TFloat    AS Amount
          
     FROM tmpCheckAll AS Movement
     
          INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.ID
                                          AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                          
          INNER JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItemContainer.ObjectId_Analyzer

          INNER JOIN Object AS Object_User ON Object_User.Id = Movement.UserId
          
     GROUP BY Object_User.ValueData
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData
     ORDER BY Object_User.ValueData
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.06.23                                                        *

*/

-- тест
-- 

SELECT * FROM gpReport_GoodsSaleChechUser(('01.06.2023')::TDateTime, ('30.06.2023')::TDateTime, 375626, '3')