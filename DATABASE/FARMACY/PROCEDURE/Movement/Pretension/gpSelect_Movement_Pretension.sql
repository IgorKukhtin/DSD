-- Function: gpSelect_Movement_Pretension()

DROP FUNCTION IF EXISTS gpSelect_Movement_Pretension (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Pretension(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber Integer
             , OperDate TDateTime
             , BranchDate TDateTime, BranchUser TVarChar
             , GoodsReceiptsDate TDateTime, SentDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalDeficit TFloat, TotalProficit TFloat, TotalSubstandard TFloat
             , TotalSummActual TFloat, TotalSummNotActual TFloat
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar, NDS TFloat
             , IncomeOperDate TDateTime, IncomeInvNumber TVarChar, JuridicalName TVarChar
             , isDeferred Boolean
             , CheckedName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
BEGIN


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);
     
     
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) -- Для роли "Кассир аптеки"
     THEN     
       vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
       IF vbUnitKey = '' THEN
          vbUnitKey := '-1';
       END IF;
       vbUnitId := vbUnitKey::Integer;
     ELSE
       vbUnitId := 0;
     END IF;
     
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          AND (ObjectLink_Unit_Juridical.ObjectId = vbUnitId OR vbUnitId = 0)
                        )
        , tmpMovement AS (SELECT Movement.Id
                               , Movement.StatusId  
                          FROM Movement 
                          WHERE Movement.DescId = zc_Movement_Pretension()
                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate)
        , tmpMI AS (SELECT Movement_Pretension.Id
                         , SUM(CASE WHEN MIBoolean_Checked.ValueData = True THEN 1 ELSE 0 END)      AS Checked
                         , Count(MI_Pretension.Id)::Integer                                         AS CountMI
                    FROM tmpMovement AS Movement_Pretension
                         LEFT JOIN MovementItem AS MI_Pretension
                                                 ON MI_Pretension.MovementId = Movement_Pretension.Id
                                                AND MI_Pretension.isErased  = FALSE
                                                AND MI_Pretension.DescId     = zc_MI_Master()
                         LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                       ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                                      AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                    GROUP BY Movement_Pretension.Id
                   )
        , tmpProtocol AS (SELECT ROW_NUMBER() OVER (PARTITION BY tmpMovement.Id ORDER BY MovementProtocol.OperDate) AS Ord,
                                 tmpMovement.Id,
                                 MovementProtocol.OperDate,
                                 MovementProtocol.UserID
                          FROM tmpMovement
                               INNER JOIN MovementProtocol ON tmpMovement.Id = MovementProtocol.MovementId
                            WHERE tmpMovement.StatusId = zc_Enum_Status_Complete()
                              AND MovementProtocol.ProtocolData ILIKE '%Статус" FieldValue = "Проведен%'
                          )
        , tmpProtocolUser AS (SELECT tmpProtocol.Id,
                                     tmpProtocol.OperDate,
                                     tmpProtocol.UserID, 
                                     Object_User.ValueData  AS UserName
                              FROM tmpProtocol
                                   LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserID 
                              WHERE tmpProtocol.Ord = 1)

       SELECT
             Movement_Pretension_View.Id
           , Movement_Pretension_View.InvNumber::Integer
           , Movement_Pretension_View.OperDate
           , COALESCE(Movement_Pretension_View.BranchDate, tmpProtocolUser.OperDate)::TDateTime AS BranchDate
           , COALESCE(Movement_Pretension_View.BranchUserName, tmpProtocolUser.UserName)::TVarChar AS BranchUserName
           , Movement_Pretension_View.GoodsReceiptsDate
           , Movement_Pretension_View.SentDate
           , Movement_Pretension_View.StatusCode
           , Movement_Pretension_View.StatusName
           , Movement_Pretension_View.TotalDeficit
           , Movement_Pretension_View.TotalProficit
           , Movement_Pretension_View.TotalSubstandard
           , Movement_Pretension_View.TotalSummActual
           , Movement_Pretension_View.TotalSummNotActual
           , Movement_Pretension_View.PriceWithVAT
           , Movement_Pretension_View.FromId
           , Movement_Pretension_View.FromName
           , Movement_Pretension_View.ToId
           , Movement_Pretension_View.ToName
           , Movement_Pretension_View.NDSKindId
           , Movement_Pretension_View.NDSKindName
           , Movement_Pretension_View.NDS
           , Movement_Pretension_View.IncomeOperDate
           , Movement_Pretension_View.IncomeInvNumber
           , Movement_Pretension_View.JuridicalName
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
           , CASE WHEN (COALESCE (tmpMI.Checked, 1) > 0 OR 
                       COALESCE (tmpMI.CountMI, 0) = 0 AND COALESCE (Movement_Pretension_View.Comment::Text, '') <> '') AND
                       Movement_Pretension_View.StatusId <> zc_Enum_Status_Complete()
                  THEN 'Актуальна' ELSE 'Неактуальна' END::TVarChar AS CheckedName
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
       FROM tmpUnit
           INNER JOIN Movement_Pretension_View ON Movement_Pretension_View.FromId = tmpUnit.UnitId
                                              AND Movement_Pretension_View.OperDate BETWEEN inStartDate AND inEndDate
           INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_Pretension_View.StatusId

           LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                     ON MovementBoolean_Deferred.MovementId = Movement_Pretension_View.Id
                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

           LEFT JOIN MovementDate AS MovementDate_Insert
                                  ON MovementDate_Insert.MovementId = Movement_Pretension_View.Id
                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
           LEFT JOIN MovementLinkObject AS MLO_Insert
                                        ON MLO_Insert.MovementId = Movement_Pretension_View.Id
                                       AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

           LEFT JOIN MovementDate AS MovementDate_Update
                                  ON MovementDate_Update.MovementId = Movement_Pretension_View.Id
                                 AND MovementDate_Update.DescId = zc_MovementDate_Update()
           LEFT JOIN MovementLinkObject AS MLO_Update
                                        ON MLO_Update.MovementId = Movement_Pretension_View.Id
                                       AND MLO_Update.DescId = zc_MovementLinkObject_Update()
           LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId 
           
           LEFT JOIN tmpMI ON tmpMI.ID = Movement_Pretension_View.Id
           
           LEFT JOIN tmpProtocolUser ON tmpProtocolUser.Id = Movement_Pretension_View.Id
  ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Pretension (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.21                                                       *
*/

-- тест
-- 
select * from gpSelect_Movement_Pretension(instartdate := ('01.03.2022')::TDateTime , inenddate := ('20.03.2022')::TDateTime , inIsErased := 'True' ,  inSession := '3');