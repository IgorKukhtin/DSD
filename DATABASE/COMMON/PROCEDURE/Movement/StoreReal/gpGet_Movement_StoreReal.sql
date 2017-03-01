-- Function: gpGet_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpGet_Movement_StoreReal(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_StoreReal (
    IN inMovementId Integer  , -- ключ Документа
    IN inOperDate   TDateTime, -- дата Документа
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , GUID TVarChar
             , InsertDate TDateTime
             , InsertName TVarChar
             , PriceListId Integer
             , PriceListName TVarChar
             , PartnerId Integer
             , PartnerName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat
             , TotalCountKg TFloat
             , TotalSummPVAT TFloat
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUserName TVarChar;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_StoreReal());
      vbUserId:= lpGetUserBySession (inSession);
      vbUserName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId);

      IF COALESCE(inMovementId, 0) = 0 
      THEN
           RETURN QUERY
             SELECT 0                                                    AS Id
                  , CAST (NEXTVAL('movement_storereal_seq') AS TVarChar) AS InvNumber
                  , CURRENT_DATE :: TDateTime                            AS OperDate
                  , Object_Status.Code                                   AS StatusCode
                  , Object_Status.Name                                   AS StatusName
                  , CAST('' AS TVarChar)                                 AS GUID
                  , CURRENT_TIMESTAMP :: TDateTime                       AS InsertDate
                  , vbUserName                                           AS InserName 
                  , CAST(0  AS Integer)                                  AS PriceListId
                  , CAST('' AS TVarChar) 			         AS PriceListName
                  , CAST(0  AS Integer)                                  AS PartnerId
                  , CAST('' AS TVarChar)                                 AS PartnerName
                  , CAST(FALSE AS Boolean)                               AS PriceWithVAT
                  , CAST(20 AS TFloat)                                   AS VATPercent
                  , CAST(0  AS TFloat)                                   AS TotalCountKg
                  , CAST(0  AS TFloat)                                   AS TotalSummPVAT
             FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
      ELSE
           RETURN QUERY
             SELECT Movement.Id                                AS Id
                  , Movement.InvNumber                         AS InvNumber
                  , Movement.OperDate                          AS OperDate
                  , Object_Status.ObjectCode                   AS StatusCode
                  , Object_Status.ValueData                    AS StatusName
                  , MovementString_GUID.ValueData              AS GUID
                  , MovementDate_Insert.ValueData              AS InsertDate 
                  , Object_User.ValueData                      AS InsertName
                  , Object_PriceList.id                        AS PriceListId
                  , Object_PriceList.ValueData                 AS PriceListName
                  , Object_Partner.id                          AS PartnerId
                  , Object_Partner.ValueData                   AS PartnerName

                  , COALESCE(MovementBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
                  , MovementFloat_VATPercent.ValueData                      AS VATPercent

                  , MovementFloat_TotalCountKg.ValueData  AS TotalCountKg
                  , MovementFloat_TotalSummPVAT.ValueData AS TotalSummPVAT
             FROM Movement
                  LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                  LEFT JOIN MovementString AS MovementString_GUID 
                                           ON MovementString_GUID.MovementId = Movement.Id
                                          AND MovementString_GUID.DescId = zc_MovementString_GUID()

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
                                         AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
             WHERE Movement.Id =  inMovementId
               AND Movement.DescId = zc_Movement_StoreReal();
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION gpGet_Movement_StoreReal (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 15.02.17                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_StoreReal (inMovementId := 1, inOperDate := CURRENT_TIMESTAMP, inSession := '9818')
