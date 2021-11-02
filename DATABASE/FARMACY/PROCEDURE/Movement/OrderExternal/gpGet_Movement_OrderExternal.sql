-- Function: gpGet_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderExternal(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , ContractId Integer, ContractName TVarChar
             , MasterId Integer, MasterInvNumber TVarChar, OrderKindName TVarChar
             , Comment TVarChar
             , Zakaz_Text TVarChar
             , Dostavka_Text TVarChar
             , OrderSumm TVarChar, OrderTime TVarChar, OrderSummComment TVarChar
             , isDeferred Boolean
             , isDifferent Boolean
             , LetterSubject      TVarChar
             , Address TVarChar, Phone TVarChar, TimeWork TVarChar, PharmacyManager TVarChar
             , isUseSubject       Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderExternal());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_orderexternal_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                     		                AS FromId
             , CAST ('' AS TVarChar) 		                AS FromName
             , 0                     		                AS ToId
             , CAST ('' AS TVarChar) 		                AS ToName
             , 0                     			        AS ContractId
             , CAST ('' AS TVarChar) 			        AS ContractName
             , 0                     			        AS MasterId
             , CAST ('' AS TVarChar) 			        AS MasterInvNumber
             , CAST ('' AS TVarChar) 			        AS OrderKindName
             , CAST ('' AS TVarChar) 		                AS Comment
             , CAST ('' AS TVarChar) 		                AS Zakaz_Text
             , CAST ('' AS TVarChar) 		                AS Dostavka_Text
             , CAST ('' AS TVarChar) 		                AS OrderSumm
             , CAST ('' AS TVarChar) 		                AS OrderTime
             , CAST ('' AS TVarChar) 		                AS OrderSummComment
             , FALSE                                            AS isDeferred
             , FALSE                                            AS isDifferent
             , CAST ('' AS TVarChar) 		                AS LetterSubject
             , CAST ('' AS TVarChar) 		                AS Address
             , CAST ('' AS TVarChar) 		                AS Phone
             , CAST ('' AS TVarChar) 		                AS TimeWork
             , CAST ('' AS TVarChar) 		                AS PharmacyManager
             , FALSE                                            AS isUseSubject

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       WITH
       tmpOrderShedule AS (SELECT ObjectLink_OrderShedule_Unit.ChildObjectId      AS UnitId
                                , ObjectLink_OrderShedule_Contract.ChildObjectId  AS ContractId      

                                , (CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat in (1,3) THEN 'Понедельник,' ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat in (1,3) THEN 'Вторник,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat in (1,3) THEN 'Среда,'       ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat in (1,3) THEN 'Четверг,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat in (1,3) THEN 'Пятница,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat in (1,3) THEN 'Суббота,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat in (1,3) THEN 'Воскресенье'  ELSE '' END) ::TVarChar   AS Zakaz_Text   --День заказа (информативно)
                                , (CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat in (2,3) THEN 'Понедельник,' ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat in (2,3) THEN 'Вторник,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat in (2,3) THEN 'Среда,'       ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat in (2,3) THEN 'Четверг,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat in (2,3) THEN 'Пятница,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat in (2,3) THEN 'Суббота,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat in (2,3) THEN 'Воскресенье'  ELSE '' END) ::TVarChar   AS Dostavka_Text   --День доставки (информативно)

                           FROM Object AS Object_OrderShedule
                              LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                                   ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                                                  AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                              LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                                    ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                                                   AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                           WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                             AND Object_OrderShedule.isErased = FALSE
                           ) 

       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName
           , Object_Contract.Id                                 AS ContractId
           , Object_Contract.ValueData                          AS ContractName
           , Movement_Master.Id                                 AS MasterId
           , ('№ '||Movement_Master.InvNumber || ' от '|| TO_CHAR(Movement_Master.Operdate , 'DD.MM.YYYY')) :: TVarChar    AS MasterInvNumber 
           , Object_OrderKind.ValueData                         AS OrderKindName
           , COALESCE (MovementString_Comment.ValueData,'')       :: TVarChar AS Comment

           , COALESCE (tmpOrderShedule.Zakaz_Text, '')   ::TVarChar   AS Zakaz_Text   --День заказа (информативно)
           , COALESCE (tmpOrderShedule.Dostavka_Text,'') ::TVarChar   AS Dostavka_Text   --День доставки (информативно)

          /* , CASE WHEN COALESCE (ObjectFloat_OrderSumm_Contract.ValueData, 0) = 0 
                  THEN CASE WHEN COALESCE (ObjectFloat_OrderSumm.ValueData, 0) = 0 
                            THEN CASE WHEN COALESCE (ObjectString_OrderSumm_Contract.ValueData, '') <> '' 
                                      THEN ObjectString_OrderSumm_Contract.ValueData 
                                      ELSE COALESCE (ObjectString_OrderSumm.ValueData,'')
                                 END
                            ELSE CAST (ObjectFloat_OrderSumm.ValueData AS NUMERIC (16, 2)) ||' ' || COALESCE (ObjectString_OrderSumm.ValueData,'')
                       END
                  ELSE CAST (ObjectFloat_OrderSumm_Contract.ValueData AS NUMERIC (16, 2)) ||' ' || COALESCE (ObjectString_OrderSumm_Contract.ValueData,'')
             END                                          ::TVarChar AS OrderSumm
             
           , CASE WHEN COALESCE (ObjectString_OrderTime_Contract.ValueData,'')  <> ''  
                  THEN ObjectString_OrderTime_Contract.ValueData 
                  ELSE COALESCE (ObjectString_OrderTime.ValueData,'') 
             END                                          ::TVarChar AS OrderTime
           */
             
           , CAST (ObjectFloat_OrderSumm_Contract.ValueData AS NUMERIC (16, 2)) ::TVarChar AS OrderSumm
           , COALESCE (ObjectString_OrderTime_Contract.ValueData,'')            ::TVarChar AS OrderTime
           , COALESCE (ObjectString_OrderSumm_Contract.ValueData,'')            ::TVarChar AS OrderSummComment

           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)  :: Boolean  AS isDeferred
           , COALESCE (MovementBoolean_Different.ValueData, FALSE) :: Boolean  AS isDifferent
           
           , MovementString_LetterSubject.ValueData                            AS LetterSubject

           , ObjectString_Unit_Address.ValueData                  AS Address
           , ObjectString_Unit_Phone.ValueData                    AS Phone
           , (CASE WHEN COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00'
                  THEN 'Пн-Пт '||LEFT ((ObjectDate_MondayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_MondayEnd.ValueData::Time)::TVarChar,5)||'; '
                  ELSE ''
             END||'' ||
             CASE WHEN COALESCE(ObjectDate_SaturdayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SaturdayEnd.ValueData ::Time,'00:00') <> '00:00'
                  THEN 'Сб '||LEFT ((ObjectDate_SaturdayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SaturdayEnd.ValueData::Time)::TVarChar,5)||'; '
                  ELSE ''
             END||''||
             CASE WHEN COALESCE(ObjectDate_SundayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SundayEnd.ValueData ::Time,'00:00') <> '00:00'
                  THEN 'Вс '||LEFT ((ObjectDate_SundayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SundayEnd.ValueData::Time)::TVarChar,5)
                  ELSE ''
             END) :: TVarChar AS TimeWork
           , ObjectString_Unit_PharmacyManager.ValueData                    AS PharmacyManager
           , COALESCE (MovementBoolean_UseSubject.ValueData, FALSE) :: Boolean AS isUseSubject
             
           
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            -- точка другого юр.лица
            LEFT JOIN MovementBoolean AS MovementBoolean_Different
                                      ON MovementBoolean_Different.MovementId = Movement.Id
                                     AND MovementBoolean_Different.DescId = zc_MovementBoolean_Different()

            LEFT JOIN MovementString AS MovementString_LetterSubject
                                     ON MovementString_LetterSubject.MovementId = Movement.Id
                                    AND MovementString_LetterSubject.DescId = zc_MovementString_LetterSubject()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Master
                                           ON MLM_Master.MovementId = Movement.Id
                                          AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MLM_Master.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                         ON MovementLinkObject_OrderKind.MovementId = Movement_Master.Id
                                        AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
            LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId
            --
/*            LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm
                                  ON ObjectFloat_OrderSumm.ObjectId = Object_From.Id
                                 AND ObjectFloat_OrderSumm.DescId = zc_ObjectFloat_Juridical_OrderSumm()
            LEFT JOIN ObjectString AS ObjectString_OrderSumm
                                   ON ObjectString_OrderSumm.ObjectId = Object_From.Id
                                  AND ObjectString_OrderSumm.DescId = zc_ObjectString_Juridical_OrderSumm()
            LEFT JOIN ObjectString AS ObjectString_OrderTime
                                  ON ObjectString_OrderTime.ObjectId = Object_From.Id
                                 AND ObjectString_OrderTime.DescId = zc_ObjectString_Juridical_OrderTime()
*/
            --
            LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm_Contract
                                  ON ObjectFloat_OrderSumm_Contract.ObjectId = Object_Contract.Id
                                 AND ObjectFloat_OrderSumm_Contract.DescId = zc_ObjectFloat_Contract_OrderSumm()
            LEFT JOIN ObjectString AS ObjectString_OrderSumm_Contract 
                                   ON ObjectString_OrderSumm_Contract.ObjectId = Object_Contract.Id
                                  AND ObjectString_OrderSumm_Contract.DescId = zc_ObjectString_Contract_OrderSumm()
            LEFT JOIN ObjectString AS ObjectString_OrderTime_Contract
                                   ON ObjectString_OrderTime_Contract.ObjectId = Object_Contract.Id
                                  AND ObjectString_OrderTime_Contract.DescId = zc_ObjectString_Contract_OrderTime()
                                 
            -- График заказа/доставки
            LEFT JOIN tmpOrderShedule ON tmpOrderShedule.ContractId = Object_Contract.Id
                                     AND tmpOrderShedule.UnitId = Object_To.Id
           
            LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                   ON ObjectString_Unit_Address.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                   ON ObjectString_Unit_Phone.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectString AS ObjectString_Unit_PharmacyManager
                                   ON ObjectString_Unit_PharmacyManager.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_Unit_PharmacyManager.DescId = zc_ObjectString_Unit_PharmacyManager()

            LEFT JOIN ObjectDate AS ObjectDate_MondayStart
                                 ON ObjectDate_MondayStart.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectDate_MondayStart.DescId = zc_ObjectDate_Unit_MondayStart()
            LEFT JOIN ObjectDate AS ObjectDate_MondayEnd
                                 ON ObjectDate_MondayEnd.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectDate_MondayEnd.DescId = zc_ObjectDate_Unit_MondayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_SaturdayStart
                                 ON ObjectDate_SaturdayStart.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectDate_SaturdayStart.DescId = zc_ObjectDate_Unit_SaturdayStart()
            LEFT JOIN ObjectDate AS ObjectDate_SaturdayEnd
                                 ON ObjectDate_SaturdayEnd.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectDate_SaturdayEnd.DescId = zc_ObjectDate_Unit_SaturdayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_SundayStart
                                 ON ObjectDate_SundayStart.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectDate_SundayStart.DescId = zc_ObjectDate_Unit_SundayStart()
            LEFT JOIN ObjectDate AS ObjectDate_SundayEnd 
                                 ON ObjectDate_SundayEnd.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectDate_SundayEnd.DescId = zc_ObjectDate_Unit_SundayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_FirstCheck
                                 ON ObjectDate_FirstCheck.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectDate_FirstCheck.DescId = zc_ObjectDate_Unit_FirstCheck()

            LEFT JOIN MovementBoolean AS MovementBoolean_UseSubject
                                      ON MovementBoolean_UseSubject.MovementId = Movement.Id
                                     AND MovementBoolean_UseSubject.DescId = zc_MovementBoolean_UseSubject()
                                     
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_OrderExternal()
 ;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.02.18         *
 22.12.16         * add Deferred
 10.05.16         *
 01.07.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderExternal (inMovementId:= 1, inOperDate:= '01.01.2019':: TDateTime,inSession:= '9818')