-- Function: gpSelect_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpSelect_Movement_StoreReal(TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_StoreReal (
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inIsErased         Boolean ,
    IN inJuridicalBasisId Integer ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusName TVarChar
             , InsertDate TDateTime
             , InsertName TVarChar
             , PriceListName TVarChar
             , PartnerName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat
             , TotalCountKg TFloat
             , TotalSummPVAT TFloat
              )
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbIsUserOrder Boolean;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StoreReal());
      vbUserId := lpGetUserBySession(inSession);

      -- определяется уровень доступа
      vbIsUserOrder := EXISTS (SELECT Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder 
                               FROM Object_RoleAccessKeyGuide_View 
                               WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId 
                                 AND Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder > 0);

      -- Результат
      RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                           UNION 
                           SELECT zc_Enum_Status_UnComplete() AS StatusId
                           UNION 
                           SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )
           , tmpRoleAccessKey_all  AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
           , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
           , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View 
                                            WHERE RoleId = zc_Enum_Role_Admin() 
                                              AND UserId = vbUserId
                                            UNION 
                                            SELECT 1 AS Id FROM tmpRoleAccessKey_user 
                                            WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll() 
                                              AND vbIsUserOrder = FALSE
                                           )
           , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId 
                                  FROM tmpRoleAccessKey_user 
                                  WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                                  UNION 
                                  SELECT tmpRoleAccessKey_all.AccessKeyId 
                                  FROM tmpRoleAccessKey_all 
                                  WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) 
                                  GROUP BY tmpRoleAccessKey_all.AccessKeyId
                                  UNION 
                                  SELECT 0 AS AccessKeyId 
                                  WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                                 )
        SELECT Movement.Id                   AS Id
             , Movement.InvNumber            AS InvNumber
             , Movement.OperDate             AS OperDate
             , Object_Status.ValueData       AS StatusName
             , MovementDate_Insert.ValueData AS InsertDate
             , Object_User.ValueData         AS InsertName
             , Object_PriceList.ValueData    AS PriceListName
             , Object_Partner.ValueData      AS PartnerName

             , COALESCE(MovementBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData                      AS VATPercent

             , MovementFloat_TotalCountKg.ValueData  AS TotalCountKg
             , MovementFloat_TotalSummPVAT.ValueData AS TotalSummPVAT
        FROM (SELECT Movement.id
              FROM tmpStatus
                   JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                                AND Movement.DescId = zc_Movement_StoreReal() 
                                AND Movement.StatusId = tmpStatus.StatusId
                   JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
             ) AS tmpMovement
             LEFT JOIN Movement ON Movement.id = tmpMovement.id

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

             LEFT JOIN MovementDate AS MovementDate_Insert 
                                    ON MovementDate_Insert.MovementId = Movement.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert 
                                          ON MovementLinkObject_Insert.MovementId = Movement.Id
                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                          ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
             LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId
           
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                          ON MovementLinkObject_Partner.MovementId = Movement.Id
                                         AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                       ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                     ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

             LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                     ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                    AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                     ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                    AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT();
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION gpSelect_Movement_StoreReal(TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 16.02.17                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_StoreReal(inStartDate := '01.12.2016', inEndDate := '01.12.2016', inJuridicalBasisId := 0, inIsErased := FALSE, inSession := zfCalc_UserAdmin())
