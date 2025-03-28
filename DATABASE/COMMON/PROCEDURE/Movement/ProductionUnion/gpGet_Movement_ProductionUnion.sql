-- Function: gpGet_Movement_ProductionUnion()

-- DROP FUNCTION gpGet_Movement_ProductionUnion (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionUnion (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionUnion (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionUnion(
    IN inMovementId  Integer,       -- ключ Документа
    IN inOperDate    TDateTime,     -- дата Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromName TVarChar
             , JuridicalId_From Integer, JuridicalName_From TVarChar
             , ToId Integer, ToName TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , isAuto Boolean, InsertDate TDateTime
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
             , MovementId_Peresort Integer, InvNumber_PeresortFull TVarChar
             , MovementId_Order Integer, InvNumber_Order TVarChar
             , isPeresort Boolean
             , isClosed Boolean
             , isEtiketka Boolean
               )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) <> 0 AND NOT EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_ProductionUnion() )
       THEN
         RAISE EXCEPTION 'Ошибка. Документа <Пересортица> не существует.';
     END IF;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                              AS Id
             , CAST (NEXTVAL ('movement_productionunion_seq') AS TVarChar) AS InvNumber
             , inOperDate                                     AS OperDate
             , Object_Status.Code                             AS StatusCode
             , Object_Status.Name                             AS StatusName
             , 0                                              AS FromId
             , CAST ('' AS TVarChar)                          AS FromName
             , 0                                              AS JuridicalId_From
             , CAST ('' as TVarChar)                          AS JuridicalName_From
             , 0                                              AS ToId
             , CAST ('' AS TVarChar)                          AS ToName
             , 0                                              AS DocumentKindId
             , CAST ('' AS TVarChar)                          AS DocumentKindName
             , 0                   	                          AS SubjectDocId
             , CAST ('' AS TVarChar)                          AS SubjectDocName
 
             , CAST (False as Boolean)                        AS isAuto
             , Null:: TDateTime                               AS InsertDate

             , 0                                              AS MovementId_Production
             , CAST ('' AS TVarChar)                          AS InvNumber_ProductionFull
             , 0                                              AS MovementId_Peresort
             , CAST ('' AS TVarChar)                          AS InvNumber_PeresortFull
             , 0                                              AS MovementId_Order
             , '' :: TVarChar                                 AS InvNumber_Order
             , FALSE  :: Boolean                              AS isPeresort
             , FALSE  :: Boolean                              AS isClosed 
             , FALSE  :: Boolean                              AS isEtiketka

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     RETURN QUERY
     SELECT
           Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
         , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
         , Object_From.Id                           AS FromId
         , (CASE WHEN Object_From.ValueData ILIKE Object_To.ValueData THEN '(' || Object_From.ObjectCode :: TVarChar ||') ' ELSE '' END || Object_From.ValueData) :: TVarChar AS FromName
         , Object_JuridicalFrom.id                  AS JuridicalId_From
         , Object_JuridicalFrom.ValueData           AS JuridicalName_From
         , Object_To.Id                             AS ToId
         , (CASE WHEN Object_From.ValueData ILIKE Object_To.ValueData THEN '(' || Object_To.ObjectCode :: TVarChar ||') '  ELSE '' END || Object_To.ValueData) :: TVarChar AS ToName
         , Object_DocumentKind.Id                   AS DocumentKindId
         , Object_DocumentKind.ValueData            AS DocumentKindName 
         , Object_SubjectDoc.Id                     AS SubjectDocId
         , Object_SubjectDoc.ValueData              AS SubjectDocName
         , COALESCE(MovementBoolean_isAuto.ValueData, False)          AS isAuto
         , COALESCE(MovementDate_Insert.ValueData,  Null:: TDateTime) AS InsertDate

         , Movement_DocumentProduction.Id           AS MovementId_Production
         , zfCalc_PartionMovementName (Movement_DocumentProduction.DescId, MovementDesc_Production.ItemName, Movement_DocumentProduction.InvNumber, Movement_DocumentProduction.OperDate) AS InvNumber_ProductionFull

         , COALESCE(Movement_Peresort.Id, -1)                         AS MovementId_Peresort
         , COALESCE(CASE WHEN Movement_Peresort.StatusId = zc_Enum_Status_Erased()
                     THEN '***'
                 WHEN Movement_Peresort.StatusId = zc_Enum_Status_UnComplete()
                     THEN '*'
                 ELSE ''
            END
         || zfCalc_PartionMovementName (Movement_Peresort.DescId, MovementDesc_Peresort.ItemName, Movement_Peresort.InvNumber, Movement_Peresort.OperDate)
           , ' ')                     :: TVarChar      AS InvNumber_PeresortFull


         , Movement_Order.Id                        AS MovementId_Order
         , ('№ ' || Movement_Order.InvNumber || ' от ' || Movement_Order.OperDate  :: Date :: TVarChar) :: TVarChar AS InvNumber_Order
         
         , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) :: Boolean AS isPeresort
         , COALESCE (MovementBoolean_Closed.ValueData, False)   :: Boolean AS isClosed  
         , COALESCE (MovementBoolean_Etiketka.ValueData, False) :: Boolean AS isEtiketka
     FROM Movement
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                       ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                      AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
          LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                       ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                      AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
          LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

          LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                    ON MovementBoolean_Peresort.MovementId = Movement.Id
                                   AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()

          LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                    ON MovementBoolean_Closed.MovementId = Movement.Id
                                   AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()

          LEFT JOIN MovementBoolean AS MovementBoolean_Etiketka
                                    ON MovementBoolean_Etiketka.MovementId = Movement.Id
                                   AND MovementBoolean_Etiketka.DescId = zc_MovementBoolean_Etiketka()

          LEFT JOIN MovementDate AS MovementDate_Insert
                                 ON MovementDate_Insert.MovementId = Movement.Id
                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                         ON MovementLinkMovement_Production.MovementId = Movement.Id
                                        AND MovementLinkMovement_Production.DescId = zc_MovementLinkMovement_Production()
          LEFT JOIN Movement AS Movement_DocumentProduction ON Movement_DocumentProduction.Id = MovementLinkMovement_Production.MovementChildId
          LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_DocumentProduction.DescId
          --пересортица
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Peresort
                                         ON MovementLinkMovement_Peresort.MovementChildId = Movement.Id
                                        AND MovementLinkMovement_Peresort.DescId          = zc_MovementLinkMovement_Production()
          LEFT JOIN Movement AS Movement_Peresort ON Movement_Peresort.Id = MovementLinkMovement_Peresort.MovementId
          LEFT JOIN MovementDesc AS MovementDesc_Peresort ON MovementDesc_Peresort.Id = Movement_Peresort.DescId

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                         ON MovementLinkMovement_Order.MovementId = Movement.Id
                                        AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
          LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract
                               ON ObjectLink_Unit_Contract.ObjectId = Object_From.Id
                              AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                               ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
          LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_Contract_Juridical.ChildObjectId

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ProductionUnion();

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.03.25         *
 21.08.23         * 
 30.10.23         *
 29.03.22         * isClosed
 31.05.17         *
 26.06.16         *
 13.06.16         *
 23.06.14                                                        *
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_ProductionUnion (inMovementId := 0, inOperDate := '01.01.2014', inSession:= '2')
