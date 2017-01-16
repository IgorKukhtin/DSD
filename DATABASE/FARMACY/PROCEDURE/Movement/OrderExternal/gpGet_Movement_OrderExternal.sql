-- Function: gpGet_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderExternal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , ContractId Integer, ContractName TVarChar
             , MasterId Integer, MasterInvNumber TVarChar, OrderKindName TVarChar
             , Comment TVarChar
             , Zakaz_Text TVarChar
             , Dostavka_Text TVarChar
             , OrderSumm TVarChar, OrderTime TVarChar
             , isDeferred Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
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
             , FALSE                                            AS isDeferred

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       WITH
       tmpOrderShedule AS (SELECT ObjectLink_OrderShedule_Unit.ChildObjectId      AS UnitId
                                , ObjectLink_OrderShedule_Contract.ChildObjectId  AS ContractId      

                                , (CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat in (1,3) THEN '�����������,' ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat in (1,3) THEN '�������,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat in (1,3) THEN '�����,'       ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat in (1,3) THEN '�������,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat in (1,3) THEN '�������,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat in (1,3) THEN '�������,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat in (1,3) THEN '�����������'  ELSE '' END) ::TVarChar   AS Zakaz_Text   --���� ������ (������������)
                                , (CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat in (2,3) THEN '�����������,' ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat in (2,3) THEN '�������,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat in (2,3) THEN '�����,'       ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat in (2,3) THEN '�������,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat in (2,3) THEN '�������,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat in (2,3) THEN '�������,'     ELSE '' END ||
                                   CASE WHEN zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat in (2,3) THEN '�����������'  ELSE '' END) ::TVarChar   AS Dostavka_Text   --���� �������� (������������)

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
           , ('� '||Movement_Master.InvNumber || ' �� '|| TO_CHAR(Movement_Master.Operdate , 'DD.MM.YYYY')) :: TVarChar    AS MasterInvNumber 
           , Object_OrderKind.ValueData                         AS OrderKindName
           , COALESCE (MovementString_Comment.ValueData,'')       :: TVarChar AS Comment

          , COALESCE (tmpOrderShedule.Zakaz_Text, '')    ::TVarChar   AS Zakaz_Text   --���� ������ (������������)
          , COALESCE (tmpOrderShedule.Dostavka_Text,'') ::TVarChar   AS Dostavka_Text   --���� �������� (������������)

           , CASE WHEN COALESCE (ObjectFloat_OrderSumm.ValueData,0) = 0 THEN COALESCE (ObjectString_OrderSumm.ValueData,'') 
                  ELSE CAST (ObjectFloat_OrderSumm.ValueData AS NUMERIC (16, 2)) ||' ' || COALESCE (ObjectString_OrderSumm.ValueData,'')
             END                                            ::TVarChar AS OrderSumm
           , COALESCE (ObjectString_OrderTime.ValueData,'') ::TVarChar AS OrderTime

           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) :: Boolean  AS isDeferred

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

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
            LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm
                                  ON ObjectFloat_OrderSumm.ObjectId = Object_From.Id
                                 AND ObjectFloat_OrderSumm.DescId = zc_ObjectFloat_Juridical_OrderSumm()
            LEFT JOIN ObjectString AS ObjectString_OrderSumm
                                   ON ObjectString_OrderSumm.ObjectId = Object_From.Id
                                  AND ObjectString_OrderSumm.DescId = zc_ObjectString_Juridical_OrderSumm()
            LEFT JOIN ObjectString AS ObjectString_OrderTime
                                  ON ObjectString_OrderTime.ObjectId = Object_From.Id
                                 AND ObjectString_OrderTime.DescId = zc_ObjectString_Juridical_OrderTime()

            -- ������ ������/��������
            LEFT JOIN tmpOrderShedule ON tmpOrderShedule.ContractId = Object_Contract.Id
                                     AND tmpOrderShedule.UnitId = Object_To.Id
           
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_OrderExternal()
 ;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.12.16         * add Deferred
 10.05.16         *
 01.07.14                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_OrderExternal (inMovementId:= 1, inSession:= '9818')